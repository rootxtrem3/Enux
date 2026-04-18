#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [[ ${EUID} -ne 0 ]]; then
    export ENUX_TARGET_USER="${ENUX_TARGET_USER:-$USER}"
    export ENUX_TARGET_HOME="${ENUX_TARGET_HOME:-$HOME}"
    exec sudo --preserve-env=ENUX_TARGET_USER,ENUX_TARGET_HOME,ENUX_REPO_URL,ENUX_REPO_REF,ENUX_DOTFILES_SUBDIR,ENUX_FORCE_DOWNLOAD \
        bash "$0" "$@"
fi

# shellcheck source=arch-to-enux/scripts/common.sh
source "${SCRIPT_DIR}/scripts/common.sh"

resolve_target_identity

if [[ ! -d "${LOCAL_DOTFILES_DIR}" ]] && ! command -v git >/dev/null 2>&1; then
    log "Installing git so dotfiles can be fetched from GitHub."
    pacman -Sy --needed --noconfirm git
fi

log "Target user: ${ENUX_TARGET_USER}"
log "Target home: ${ENUX_TARGET_HOME}"

dotfiles_dir="$("${SCRIPT_DIR}/scripts/download-dotfiles.sh")"
"${SCRIPT_DIR}/scripts/install-packages.sh"
"${SCRIPT_DIR}/scripts/apply-dotfiles.sh" "${dotfiles_dir}"
"${SCRIPT_DIR}/scripts/rename-system.sh" "${dotfiles_dir}"

log "EnuxOS UI and branding have been applied."
log "Log out and start the 'EnuxOS' session, or launch Hyprland directly."
