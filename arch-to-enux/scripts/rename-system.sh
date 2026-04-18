#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=arch-to-enux/scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

dotfiles_dir=${1:-}
[[ -n "${dotfiles_dir}" ]] || die "Usage: rename-system.sh <dotfiles-dir>"

system_payload="${dotfiles_dir}/system"
[[ -d "${system_payload}" ]] || die "The dotfiles payload is missing ${system_payload}."

timestamp=$(date +%Y%m%d-%H%M%S)
backup_root="/var/lib/enux/backups/system/${timestamp}"

backup_system_file() {
    local path=$1
    local relative_path=${path#/}

    if [[ -e "${path}" || -L "${path}" ]]; then
        mkdir -p "${backup_root}/$(dirname -- "${relative_path}")"
        cp -a "${path}" "${backup_root}/${relative_path}"
    fi
}

mkdir -p "${backup_root}"

backup_system_file /usr/lib/os-release
backup_system_file /etc/os-release
backup_system_file /etc/issue
backup_system_file /usr/share/wayland-sessions/enux.desktop

log "Writing EnuxOS branding files."
install -Dm644 "${system_payload}/usr/lib/os-release" /usr/lib/os-release
ln -sf ../usr/lib/os-release /etc/os-release
install -Dm644 "${system_payload}/etc/issue" /etc/issue
install -Dm644 "${system_payload}/usr/share/wayland-sessions/enux.desktop" /usr/share/wayland-sessions/enux.desktop

log "System branding updated."
