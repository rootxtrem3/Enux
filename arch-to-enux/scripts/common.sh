#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ENUX_ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)
LOCAL_DOTFILES_DIR="${ENUX_ROOT}/dotfiles"
PACKAGES_DIR="${ENUX_ROOT}/packages"
ENUX_REPO_URL="${ENUX_REPO_URL:-https://github.com/rootxtrem3/Enux}"
ENUX_REPO_REF="${ENUX_REPO_REF:-master}"
ENUX_DOTFILES_SUBDIR="${ENUX_DOTFILES_SUBDIR:-arch-to-enux/dotfiles}"
ENUX_CACHE_ROOT="${ENUX_CACHE_ROOT:-/tmp/enux-bootstrap}"

log() {
    printf '[enux] %s\n' "$*" >&2
}

warn() {
    printf '[enux] warning: %s\n' "$*" >&2
}

die() {
    printf '[enux] error: %s\n' "$*" >&2
    exit 1
}

resolve_target_identity() {
    if [[ -z "${ENUX_TARGET_USER:-}" ]]; then
        if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
            ENUX_TARGET_USER="${SUDO_USER}"
        else
            ENUX_TARGET_USER="$(logname 2>/dev/null || true)"
        fi
    fi

    if [[ -z "${ENUX_TARGET_USER:-}" || "${ENUX_TARGET_USER}" == "root" ]]; then
        ENUX_TARGET_USER="$(
            awk -F: '$3 >= 1000 && $1 != "nobody" { print $1; exit }' /etc/passwd
        )"
    fi

    [[ -n "${ENUX_TARGET_USER:-}" ]] || die "Could not detect the non-root user to receive the Enux dotfiles."

    if [[ -z "${ENUX_TARGET_HOME:-}" ]]; then
        ENUX_TARGET_HOME="$(getent passwd "${ENUX_TARGET_USER}" | cut -d: -f6)"
    fi

    [[ -n "${ENUX_TARGET_HOME:-}" ]] || die "Could not resolve the home directory for ${ENUX_TARGET_USER}."
    [[ -d "${ENUX_TARGET_HOME}" ]] || die "Home directory ${ENUX_TARGET_HOME} does not exist."

    export ENUX_TARGET_USER ENUX_TARGET_HOME
}

run_as_target_user() {
    if command -v sudo >/dev/null 2>&1; then
        sudo -H -u "${ENUX_TARGET_USER}" "$@"
        return
    fi

    if command -v runuser >/dev/null 2>&1; then
        runuser -u "${ENUX_TARGET_USER}" -- "$@"
        return
    fi

    die "Neither sudo nor runuser is available to execute commands as ${ENUX_TARGET_USER}."
}

load_package_file() {
    local package_file=$1

    [[ -f "${package_file}" ]] || return 0

    sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "${package_file}"
}
