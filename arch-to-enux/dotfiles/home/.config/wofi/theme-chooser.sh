#!/usr/bin/env bash
set -euo pipefail

WOFI_CONF="$HOME/.config/wofi/theme-chooser.conf"
WOFI_STYLE="$HOME/.config/wofi/theme-chooser.css"

choice=$(printf "Current (Matugen)\nCyberpunk / Cyberdeck\n" \
  | wofi --show dmenu --prompt "Hyprland UI" --conf "$WOFI_CONF" --style "$WOFI_STYLE")

case "$choice" in
  "Current (Matugen)")
    "$HOME/.config/hypr/theme-switcher.sh" current
    ;;
  "Cyberpunk / Cyberdeck")
    "$HOME/.config/hypr/theme-switcher.sh" cyberpunk
    ;;
  *)
    exit 0
    ;;
 esac
