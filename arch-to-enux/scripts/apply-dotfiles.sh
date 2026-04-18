#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=arch-to-enux/scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

resolve_target_identity

dotfiles_dir=${1:-}
[[ -n "${dotfiles_dir}" ]] || die "Usage: apply-dotfiles.sh <dotfiles-dir>"

home_payload="${dotfiles_dir}/home"
[[ -d "${home_payload}" ]] || die "The dotfiles payload is missing ${home_payload}."

timestamp=$(date +%Y%m%d-%H%M%S)
backup_root="${ENUX_TARGET_HOME}/.local/state/enux-backups/${timestamp}"

backup_home_payload() {
    local source_root=$1
    local destination_root=$2
    local relative_path
    local target_path

    while IFS= read -r -d '' relative_path; do
        target_path="${ENUX_TARGET_HOME}/${relative_path}"
        if [[ -e "${target_path}" || -L "${target_path}" ]]; then
            mkdir -p "${destination_root}/$(dirname -- "${relative_path}")"
            cp -a "${target_path}" "${destination_root}/${relative_path}"
        fi
    done < <(cd "${source_root}" && find . \( -type f -o -type l \) -print0 | sed -z 's#^\./##')
}

mkdir -p "${ENUX_TARGET_HOME}" /etc/skel
backup_home_payload "${home_payload}" "${backup_root}"

if [[ -d "${backup_root}" ]]; then
    log "Existing user config was backed up to ${backup_root}."
fi

log "Applying Enux dotfiles to ${ENUX_TARGET_HOME}."
rsync -a --chown="${ENUX_TARGET_USER}:${ENUX_TARGET_USER}" "${home_payload}/" "${ENUX_TARGET_HOME}/"

log "Updating /etc/skel for future users."
rsync -a "${home_payload}/" /etc/skel/

if command -v xdg-user-dirs-update >/dev/null 2>&1; then
    run_as_target_user xdg-user-dirs-update
fi

log "Dotfiles applied."
