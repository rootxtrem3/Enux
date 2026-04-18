#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=arch-to-enux/scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

resolve_target_identity

ensure_yay() {
    if command -v yay >/dev/null 2>&1; then
        log "yay is already installed."
        return
    fi

    log "Installing yay from the AUR."
    pacman -S --needed --noconfirm git base-devel

    build_root=$(mktemp -d "/tmp/enux-yay.XXXXXX")
    chown "${ENUX_TARGET_USER}:${ENUX_TARGET_USER}" "${build_root}"

    trap 'rm -rf "${build_root}"' RETURN

    run_as_target_user git clone https://aur.archlinux.org/yay.git "${build_root}/yay" >/dev/null
    (
        cd "${build_root}/yay"
        run_as_target_user makepkg -si --noconfirm
    )
}

mapfile -t pacman_packages < <(load_package_file "${PACKAGES_DIR}/pacman.txt")

if ((${#pacman_packages[@]} > 0)); then
    log "Installing required pacman packages."
    pacman -Syu --needed --noconfirm "${pacman_packages[@]}"
fi

ensure_yay

mapfile -t aur_packages < <(load_package_file "${PACKAGES_DIR}/aur.txt")

if ((${#aur_packages[@]} > 0)); then
    log "Installing Enux AUR packages with yay."
    run_as_target_user yay -S --needed --noconfirm "${aur_packages[@]}"
fi

log "Package checks completed."
