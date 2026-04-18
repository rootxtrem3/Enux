#!/usr/bin/env bash
set -euo pipefail

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

shorten() {
  local text="$1"
  local max_len="$2"
  if [ "${#text}" -le "$max_len" ]; then
    printf '%s' "$text"
  else
    printf '%s…' "${text:0:max_len-1}"
  fi
}

fmt_line() {
  local label="$1"
  local value="$2"
  printf '%-8s %s' "$label" "$value"
}

format_uptime() {
  local total
  total="$(cut -d. -f1 /proc/uptime)"
  local days hours mins
  days=$((total / 86400))
  hours=$(((total % 86400) / 3600))
  mins=$(((total % 3600) / 60))

  if [ "$days" -gt 0 ]; then
    printf '%sd %sh %sm' "$days" "$hours" "$mins"
  elif [ "$hours" -gt 0 ]; then
    printf '%sh %sm' "$hours" "$mins"
  else
    printf '%sm' "$mins"
  fi
}

memory_usage() {
  awk '
    /MemTotal:/ { total=$2 }
    /MemAvailable:/ { avail=$2 }
    END {
      used=total-avail
      printf "%.2f GiB / %.2f GiB (%d%%)", used/1048576, total/1048576, (used*100)/total
    }
  ' /proc/meminfo
}

os_name="$(trim "$(source /etc/os-release && printf '%s' "${PRETTY_NAME:-Linux}")")"
product_version="$(trim "$(cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null || true)")"
product_name="$(trim "$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || true)")"
if [ -n "$product_version" ] && [ -n "$product_name" ]; then
  host_name="${product_version} (${product_name})"
elif [ -n "$product_name" ]; then
  host_name="$product_name"
else
  host_name="$(hostname)"
fi
kernel_name="$(uname -r)"
uptime_value="$(format_uptime)"

pacman_count="$(pacman -Qq 2>/dev/null | wc -l | tr -d ' ')"
flatpak_count="$(flatpak list 2>/dev/null | wc -l | tr -d ' ')"
shell_name="${SHELL##*/}"
shell_version="$(trim "$("$SHELL" --version 2>/dev/null | head -n 1 | sed 's/ version//; s/,.*//')")"
if [ -n "${KITTY_PID:-}" ]; then
  terminal_name="kitty"
else
  terminal_name="${TERM_PROGRAM:-${TERM:-unknown}}"
fi

cpu_name="$(trim "$(lscpu | sed -n 's/^Model name:[[:space:]]*//p' | head -n 1)")"
gpu_name="$(trim "$(lspci | sed -n '/VGA compatible controller\|3D controller\|Display controller/{s/.*: //; p; q}')")"
memory_value="$(memory_usage)"
storage_value="$(df -h --output=used,size,pcent / | awk 'END {print $1 " / " $2 " (" $3 ")"}')"

col_width=30
inner_width=$((col_width - 4))
gap='  '

system_lines=(
  "$(fmt_line "OS" "$(shorten "$os_name" 17)")"
  "$(fmt_line "Host" "$(shorten "$host_name" 17)")"
  "$(fmt_line "Kernel" "$(shorten "$kernel_name" 17)")"
  "$(fmt_line "Uptime" "$(shorten "$uptime_value" 17)")"
)

software_lines=(
  "$(fmt_line "Pkgs" "$(shorten "${pacman_count} pacman, ${flatpak_count} flatpak" 17)")"
  "$(fmt_line "Shell" "$(shorten "${shell_version:-$shell_name}" 17)")"
  "$(fmt_line "Term" "$(shorten "$terminal_name" 17)")"
  ""
)

hardware_lines=(
  "$(fmt_line "CPU" "$(shorten "$cpu_name" 17)")"
  "$(fmt_line "GPU" "$(shorten "$gpu_name" 17)")"
  ""
  ""
)

storage_lines=(
  "$(fmt_line "Memory" "$(shorten "$memory_value" 13)")"
  "$(fmt_line "Root" "$(shorten "$storage_value" 17)")"
  ""
  ""
)

print_border_top() {
  local title="$1"
  printf '╭─ %-*s ─╮' $((inner_width - 4)) "$title"
}

print_border_bottom() {
  local i
  printf '╰'
  for ((i = 0; i < col_width - 2; i++)); do
    printf '─'
  done
  printf '╯'
}

print_row() {
  local left="$1"
  local right="$2"
  printf '│ %-*s │%s│ %-*s │\n' \
    "$inner_width" "$left" \
    "$gap" \
    "$inner_width" "$right"
}

print_border_top "SYSTEM"
printf '%s' "$gap"
print_border_top "SOFTWARE"
printf '\n'

for i in 0 1 2 3; do
  print_row "${system_lines[$i]}" "${software_lines[$i]}"
done

print_border_bottom
printf '%s' "$gap"
print_border_bottom
printf '\n'

print_border_top "HARDWARE"
printf '%s' "$gap"
print_border_top "STORAGE"
printf '\n'

for i in 0 1 2 3; do
  print_row "${hardware_lines[$i]}" "${storage_lines[$i]}"
done

print_border_bottom
printf '%s' "$gap"
print_border_bottom
printf '\n'
