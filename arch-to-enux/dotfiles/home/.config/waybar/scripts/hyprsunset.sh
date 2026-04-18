#!/usr/bin/env bash
set -u

DEFAULT_WARM=4300
DEFAULT_NEUTRAL=6000

read_temp_from_cmdline() {
  local pid="$1"
  local cmdline temp=""
  cmdline=$(tr '\0' ' ' < "/proc/${pid}/cmdline" 2>/dev/null || true)
  [ -z "$cmdline" ] && return 0

  # shellcheck disable=SC2086
  set -- $cmdline
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -t|--temperature)
        shift
        [ "$#" -gt 0 ] && temp="$1"
        ;;
      --temperature=*)
        temp="${1#*=}"
        ;;
    esac
    shift || break
  done

  [ -n "$temp" ] && printf '%s\n' "$temp"
}

start_hyprsunset() {
  local temp="$1"
  pkill -x hyprsunset >/dev/null 2>&1 || true
  nohup hyprsunset -t "$temp" >/dev/null 2>&1 &
}

case "${1:-status}" in
  toggle)
    pid=$(pgrep -x hyprsunset | head -n1 || true)
    current=""
    [ -n "${pid:-}" ] && current=$(read_temp_from_cmdline "$pid")
    if [ -n "$current" ] && [ "$current" -lt 5600 ]; then
      start_hyprsunset "$DEFAULT_NEUTRAL"
    else
      start_hyprsunset "$DEFAULT_WARM"
    fi
    exit 0
    ;;
  warm)
    start_hyprsunset "$DEFAULT_WARM"
    exit 0
    ;;
  reset)
    start_hyprsunset "$DEFAULT_NEUTRAL"
    exit 0
    ;;
esac

pid=$(pgrep -x hyprsunset | head -n1 || true)
if [ -z "${pid:-}" ]; then
  printf '{"text":"󰖨 off","tooltip":"hyprsunset not running","class":"off"}\n'
  exit 0
fi

temp=$(read_temp_from_cmdline "$pid")
[ -z "$temp" ] && temp=$DEFAULT_NEUTRAL

if [ "$temp" -lt 5600 ]; then
  icon="󰖔"
  state="Warm"
  class="warm"
else
  icon="󰖨"
  state="Neutral"
  class="neutral"
fi

printf '{"text":"%s %sK","tooltip":"%s (%sK)\\nLeft: Toggle\\nMiddle: Neutral\\nRight: Warm","class":"%s"}\n' "$icon" "$temp" "$state" "$temp" "$class"
