#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${ROOT_DIR}/enux-profile/releng"
LOCALREPO_DIR="${ROOT_DIR}/localrepo"

status=0

pass() {
    printf '[PASS] %s\n' "$1"
}

warn() {
    printf '[WARN] %s\n' "$1"
}

fail() {
    printf '[FAIL] %s\n' "$1"
    status=1
}

require_file() {
    local path="$1"
    local label="$2"
    if [[ -e "${path}" ]]; then
        pass "${label}: ${path}"
    else
        fail "${label}: missing ${path}"
    fi
}

require_grep() {
    local pattern="$1"
    local path="$2"
    local label="$3"
    if grep -Eq "${pattern}" "${path}"; then
        pass "${label}: ${path}"
    else
        fail "${label}: expected pattern '${pattern}' in ${path}"
    fi
}

echo "Checking Enux live ISO prerequisites in ${ROOT_DIR}"

require_file "${LOCALREPO_DIR}/enux.db" "Local pacman repo symlink"
require_file "${LOCALREPO_DIR}/enux.db.tar.gz" "Local pacman repo database archive"
require_file "${LOCALREPO_DIR}/enux.files" "Local pacman repo files symlink"
require_file "${LOCALREPO_DIR}/enux.files.tar.gz" "Local pacman repo files archive"

shopt -s nullglob
calamares_pkgs=( "${LOCALREPO_DIR}"/calamares-*.pkg.tar.* )
shopt -u nullglob
if (( ${#calamares_pkgs[@]} > 0 )); then
    pass "Calamares package artifact present"
else
    fail "No local Calamares package found in ${LOCALREPO_DIR}; build cannot install 'calamares'"
fi

require_grep '^\[enux\]$' "${PROFILE_DIR}/pacman.conf" "Custom repo configured"
require_grep '^Server = file:///home/rootx/big_project/Enux/localrepo$' "${PROFILE_DIR}/pacman.conf" "Custom repo path configured"
require_grep '^calamares$' "${PROFILE_DIR}/packages.x86_64" "Package list includes Calamares"
require_grep "bootmodes=\\('bios\\.syslinux'" "${PROFILE_DIR}/profiledef.sh" "BIOS boot mode enabled"
require_grep "'uefi\\.systemd-boot'\\)" "${PROFILE_DIR}/profiledef.sh" "UEFI boot mode enabled"

require_file "${PROFILE_DIR}/grub/grub.cfg" "GRUB boot configuration"
require_file "${PROFILE_DIR}/syslinux/syslinux.cfg" "Syslinux boot configuration"
require_file "${PROFILE_DIR}/airootfs/etc/mkinitcpio.conf.d/archiso.conf" "Archiso initramfs configuration"
require_file "${PROFILE_DIR}/airootfs/etc/mkinitcpio.d/linux.preset" "Kernel preset"

require_file "${PROFILE_DIR}/airootfs/etc/calamares/settings.conf" "Calamares settings"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/modules/unpackfs.conf" "Calamares unpackfs module"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/modules/displaymanager.conf" "Calamares display manager module"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/modules/services-systemd.conf" "Calamares services module"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/modules/users.conf" "Calamares users module"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/modules/welcome.conf" "Calamares welcome module"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/branding/enux/branding.desc" "Calamares branding"
require_file "${PROFILE_DIR}/airootfs/etc/calamares/branding/enux/show.qml" "Calamares slideshow"

require_file "${PROFILE_DIR}/airootfs/usr/local/bin/launch-enux-installer" "Installer launcher"
require_file "${PROFILE_DIR}/airootfs/usr/share/applications/enux-installer.desktop" "Installer desktop entry"
require_file "${PROFILE_DIR}/airootfs/etc/skel/.config/autostart/enux-installer.desktop" "Installer autostart entry"
require_file "${PROFILE_DIR}/airootfs/etc/skel/Desktop/Install Enux.desktop" "Installer desktop shortcut"
require_file "${PROFILE_DIR}/airootfs/etc/gdm/custom.conf" "GDM live-session autologin config"
require_file "${PROFILE_DIR}/airootfs/etc/systemd/system/enux-live-user.service" "Live user service"
require_file "${PROFILE_DIR}/airootfs/etc/systemd/system/multi-user.target.wants/enux-live-user.service" "Live user service enabled"
require_file "${PROFILE_DIR}/airootfs/etc/systemd/system/display-manager.service" "Display manager symlink"
require_file "${PROFILE_DIR}/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service" "NetworkManager enabled"
require_file "${PROFILE_DIR}/airootfs/etc/sudoers.d/10-enux-live" "Passwordless sudo for live user"

if tar -tf "${LOCALREPO_DIR}/enux.db.tar.gz" >/dev/null 2>&1; then
    if [[ -n "$(tar -tf "${LOCALREPO_DIR}/enux.db.tar.gz")" ]]; then
        pass "Local pacman repo database is readable"
    else
        warn "Local pacman repo database is readable but empty"
    fi
else
    fail "Local pacman repo database is not a readable tar archive"
fi

if command -v mkarchiso >/dev/null 2>&1; then
    pass "mkarchiso is installed"
else
    warn "mkarchiso is not installed on this machine"
fi

if command -v repo-add >/dev/null 2>&1; then
    pass "repo-add is installed"
else
    warn "repo-add is not installed on this machine"
fi

if command -v pacman >/dev/null 2>&1; then
    pass "pacman is installed"
else
    warn "pacman is not installed on this machine"
fi

echo
if (( status == 0 )); then
    echo "Result: no blocking repository/profile issues detected by this local check."
else
    echo "Result: blocking issues detected. Fix the [FAIL] items before building the ISO."
fi

exit "${status}"
