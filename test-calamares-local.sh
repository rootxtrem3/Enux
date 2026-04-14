#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
work_root="$repo_root/work/x86_64/airootfs"
profile_branding="$repo_root/enux-profile/releng/airootfs/etc/calamares/branding/enux/branding.desc"
live_branding="$work_root/etc/calamares/branding/enux/branding.desc"

if [[ ! -x "$work_root/usr/bin/calamares" ]]; then
  echo "Missing Calamares binary: $work_root/usr/bin/calamares" >&2
  exit 1
fi

if [[ ! -f "$work_root/etc/calamares/settings.conf" ]]; then
  echo "Missing settings file: $work_root/etc/calamares/settings.conf" >&2
  exit 1
fi

if [[ ! -f "$profile_branding" ]]; then
  echo "Missing branding source file: $profile_branding" >&2
  exit 1
fi

tmpdir="$(mktemp -d /tmp/calamares-test.XXXXXX)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

mkdir -p "$tmpdir/branding/enux" "$tmpdir/modules"

cp "$work_root/etc/calamares/settings.conf" "$tmpdir/settings.conf"
cp "$work_root/etc/calamares/modules/"*.conf "$tmpdir/modules/"
cp "$work_root/etc/calamares/branding/enux/show.qml" "$tmpdir/branding/enux/show.qml"
cp "$profile_branding" "$tmpdir/branding/enux/branding.desc"

ln -s "$work_root/usr/share/calamares/qml" "$tmpdir/qml"
ln -s "$work_root/usr/share/calamares/branding/default" "$tmpdir/branding/default"

echo "Temporary test root: $tmpdir"
echo "Branding source: $profile_branding"
if [[ -f "$live_branding" ]]; then
  echo "Live-tree branding: $live_branding"
fi

if [[ "${1:-}" == "--offscreen" ]]; then
  qt_platform="offscreen"
else
  qt_platform="xcb"
fi

env \
  HOME=/tmp \
  XDG_CACHE_HOME=/tmp/.cache \
  XDG_CONFIG_HOME=/tmp/.config \
  XDG_DATA_DIRS="$work_root/usr/share" \
  LD_LIBRARY_PATH="$work_root/usr/lib:$work_root/usr/lib/calamares" \
  QT_QPA_PLATFORM="$qt_platform" \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  CALAMARES_MODULE_PATH="$work_root/usr/lib/calamares/modules" \
  "$work_root/usr/bin/calamares" -d -c "$tmpdir"
