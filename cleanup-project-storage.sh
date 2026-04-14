#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

targets=(
  "out"
  "work"
  "localrepo"
)

usage() {
  cat <<'EOF'
Usage: ./cleanup-project-storage.sh [--force]

Removes project-local build outputs that consume storage while leaving
Calamares package sources and artifacts intact.

Default mode is a dry run. Pass --force to delete the files.
EOF
}

dry_run=1
if [[ "${1:-}" == "--force" ]]; then
  dry_run=0
elif [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
elif [[ $# -gt 0 ]]; then
  usage >&2
  exit 1
fi

existing_paths=()

for rel in "${targets[@]}"; do
  abs="${repo_root}/${rel}"
  if [[ -e "${abs}" ]]; then
    existing_paths+=("${abs}")
  fi
done

if (( ${#existing_paths[@]} == 0 )); then
  echo "Nothing to remove."
  exit 0
fi

echo "Project-local storage targets:"
du -sh "${existing_paths[@]}" 2>/dev/null || true
echo

if (( dry_run == 1 )); then
  echo "Dry run only. Re-run with --force to delete these paths."
  exit 0
fi

rm -rf -- "${existing_paths[@]}"
echo "Removed selected build outputs and package artifacts."
