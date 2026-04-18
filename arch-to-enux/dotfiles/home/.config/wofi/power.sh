#!/usr/bin/env bash
set -euo pipefail

WOFI_CONF="$HOME/.config/wofi/power.conf"
WOFI_STYLE="$HOME/.config/wofi/power.css"

choice=$(printf '%s\n' \
  '  Lock' \
  '󰍃  Logout' \
  '󰤄  Suspend' \
  '󰜉  Reboot' \
  '⏻  Shutdown' \
  | wofi --show dmenu --prompt 'Power' --conf "$WOFI_CONF" --style "$WOFI_STYLE")

case "$choice" in
  '  Lock')
    if command -v hyprlock >/dev/null 2>&1; then
      hyprlock
    else
      loginctl lock-session
    fi
    ;;
  '󰍃  Logout')
    hyprshutdown --top-label 'Logging out...'
    ;;
  '󰤄  Suspend')
    systemctl suspend
    ;;
  '󰜉  Reboot')
    hyprshutdown --top-label 'Rebooting...' --post-cmd 'systemctl reboot'
    ;;
  '⏻  Shutdown')
    hyprshutdown --top-label 'Shutting down...' --post-cmd 'systemctl poweroff'
    ;;
  *)
    exit 0
    ;;
esac
