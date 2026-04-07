#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${ROOT_DIR}/enux-profile/releng"
OUT_DIR="${ROOT_DIR}/out"
WORK_DIR="${ROOT_DIR}/work"

if [[ ! -d "${PROFILE_DIR}" ]]; then
    echo "Missing profile directory: ${PROFILE_DIR}" >&2
    exit 1
fi

mkdir -p "${OUT_DIR}" "${WORK_DIR}"

if ! command -v mkarchiso >/dev/null 2>&1; then
    echo "mkarchiso is not installed. Install archiso first:" >&2
    echo "  sudo pacman -Syu --noconfirm archiso git base-devel" >&2
    exit 1
fi

if ! pacman --config "${PROFILE_DIR}/pacman.conf" -Ss '^enux/calamares$' >/dev/null 2>&1; then
    cat >&2 <<'EOF'
Warning: The Enux profile cannot currently resolve calamares from its configured repositories.
Build or publish the Calamares package into /home/rootx/big_project/Enux/localrepo
and keep the [enux] repository enabled in enux-profile/releng/pacman.conf.
EOF
fi

if [[ "${EUID}" -ne 0 ]]; then
    exec sudo mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROFILE_DIR}"
fi

mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROFILE_DIR}"
