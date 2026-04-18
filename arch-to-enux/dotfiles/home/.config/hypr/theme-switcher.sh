#!/usr/bin/env bash
set -euo pipefail

theme="${1:-}"

theme_conf="$HOME/.config/hypr/theme.conf"
waybar_dir="$HOME/.config/waybar"
waybar_style="$waybar_dir/style.css"
waybar_config="$waybar_dir/config"

case "$theme" in
  current)
    target="$HOME/.config/hypr/themes/current.conf"
    wb_style="$waybar_dir/styles/matugen.css"
    wb_config="$waybar_dir/configs/default.json"
    ;;
  cyberpunk|cyberdeck)
    target="$HOME/.config/hypr/themes/cyberpunk.conf"
    wb_style="$waybar_dir/styles/cyberpunk-island.css"
    wb_config="$waybar_dir/configs/cyberpunk-island.json"
    ;;
  *)
    echo "Usage: $0 {current|cyberpunk}" >&2
    exit 1
    ;;
 esac

if [ ! -f "$target" ]; then
  echo "Theme file not found: $target" >&2
  exit 1
fi

printf 'source = %s\n' "$target" > "$theme_conf"

# Sync Waybar with the selected UI (if available)
if [ -f "$wb_style" ]; then
  cp "$wb_style" "$waybar_style"
fi
if [ -f "$wb_config" ]; then
  cp "$wb_config" "$waybar_config"
fi

# Reload Waybar to apply changes
pkill waybar || true
nohup waybar >/dev/null 2>&1 &

# Apply immediately
hyprctl reload
