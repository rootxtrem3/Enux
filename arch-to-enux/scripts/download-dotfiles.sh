#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=arch-to-enux/scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

if [[ "${ENUX_FORCE_DOWNLOAD:-0}" != "1" && -d "${LOCAL_DOTFILES_DIR}" ]]; then
    printf '%s\n' "${LOCAL_DOTFILES_DIR}"
    exit 0
fi

command -v git >/dev/null 2>&1 || die "git is required to fetch the Enux dotfiles."

work_dir=$(mktemp -d "/tmp/enux-dotfiles.XXXXXX")
cache_dir="${ENUX_CACHE_ROOT}/dotfiles"
repo_dir="${work_dir}/repo"

rm -rf "${cache_dir}"
mkdir -p "${cache_dir}"

trap 'rm -rf "${work_dir}"' EXIT

log "Fetching ${ENUX_DOTFILES_SUBDIR} from ${ENUX_REPO_URL} (${ENUX_REPO_REF})."
git clone --depth 1 --filter=blob:none --sparse --branch "${ENUX_REPO_REF}" "${ENUX_REPO_URL}" "${repo_dir}" >/dev/null
git -C "${repo_dir}" sparse-checkout set "${ENUX_DOTFILES_SUBDIR}" >/dev/null

[[ -d "${repo_dir}/${ENUX_DOTFILES_SUBDIR}" ]] || die "The downloaded repo did not contain ${ENUX_DOTFILES_SUBDIR}."

cp -a "${repo_dir}/${ENUX_DOTFILES_SUBDIR}/." "${cache_dir}/"

printf '%s\n' "${cache_dir}"
