#!/usr/bin/env bash
set -euo pipefail

WAYBAR_DIR="$HOME/.config/waybar"
STYLES_DIR="$WAYBAR_DIR/styles"
CONFIGS_DIR="$WAYBAR_DIR/configs"
WOFI_CONF="$HOME/.config/wofi/waybar-style.conf"
WOFI_STYLE="$HOME/.config/wofi/waybar-style.css"

if [ ! -d "$STYLES_DIR" ]; then
  echo "Missing styles directory: $STYLES_DIR" >&2
  exit 1
fi

categories=(
  "Styles (colors only)"
  "Top layouts"
  "Bottom layouts"
  "Left layouts"
  "Right layouts"
)

category=$(printf '%s\n' "${categories[@]}" | wofi --show dmenu --prompt "Waybar Category" --conf "$WOFI_CONF" --style "$WOFI_STYLE" || true)

if [ -z "$category" ]; then
  exit 0
fi

case "$category" in
  "Styles (colors only)")
    choices=(
      "Matugen (current)"
      "Glass"
      "Pill"
      "Compact"
      "Retro"
      "Cyberpunk"
      "Synthwave"
      "Neon Noir"
      "Sandstone"
      "Graphite"
      "Aurora"
      "Holo"
      "Tactical"
      "Mono"
      "Classic"
    )
    ;;
  "Top layouts")
    choices=(
      "Profile: Default (current)"
      "Profile: Synthwave Split (center)"
      "Profile: Neon Noir Dashboard"
      "Profile: Aurora HUD (center)"
      "Profile: Mono Focus (top)"
      "Profile: Graphite Right Stack"
      "Profile: Single Module (center)"
      "Profile: Ultra Thin (top)"
      "Profile: Top-Left Compact"
      "Ref: Gradient"
      "Ref: Top Single Block"
      "Ref: Top Split Blocks"
    )
    ;;
  "Bottom layouts")
    choices=(
      "Profile: Cyberpunk Minimal (bottom)"
    )
    ;;
  "Left layouts")
    choices=(
      "Profile: Tactical Dock (left)"
    )
    ;;
  "Right layouts")
    choices=(
      "Profile: Right Dock"
      "Ref: Base"
      "Ref: Split Style"
      "Ref: Floating Shadow"
      "Ref: Vertical"
      "Ref: Vertical Opaque"
      "Ref: Vertical Transparent"
    )
    ;;
  *)
    exit 0
    ;;
esac

choice=$(printf '%s\n' "${choices[@]}" | wofi --show dmenu --prompt "Waybar Choice" --conf "$WOFI_CONF" --style "$WOFI_STYLE" || true)

if [ -z "$choice" ]; then
  exit 0
fi

config_file=""

case "$choice" in
  "Matugen (current)") style_file="$STYLES_DIR/matugen.css" ;;
  "Glass") style_file="$STYLES_DIR/glass.css" ;;
  "Pill") style_file="$STYLES_DIR/pill.css" ;;
  "Compact") style_file="$STYLES_DIR/compact.css" ;;
  "Retro") style_file="$STYLES_DIR/retro.css" ;;
  "Cyberpunk") style_file="$STYLES_DIR/cyberpunk.css" ;;
  "Synthwave") style_file="$STYLES_DIR/synthwave.css" ;;
  "Neon Noir") style_file="$STYLES_DIR/neon-noir.css" ;;
  "Sandstone") style_file="$STYLES_DIR/sandstone.css" ;;
  "Graphite") style_file="$STYLES_DIR/graphite.css" ;;
  "Aurora") style_file="$STYLES_DIR/aurora.css" ;;
  "Holo") style_file="$STYLES_DIR/holo.css" ;;
  "Tactical") style_file="$STYLES_DIR/tactical.css" ;;
  "Mono") style_file="$STYLES_DIR/mono.css" ;;
  "Classic") style_file="$STYLES_DIR/classic.css" ;;
  "Ref: Base") style_file="$STYLES_DIR/ref-base.css"; config_file="${config_file:-$CONFIGS_DIR/ref-base.json}" ;;
  "Ref: Split Style") style_file="$STYLES_DIR/ref-split.css"; config_file="${config_file:-$CONFIGS_DIR/ref-base.json}" ;;
  "Ref: Floating Shadow") style_file="$STYLES_DIR/ref-floating-shadow.css"; config_file="${config_file:-$CONFIGS_DIR/ref-base.json}" ;;
  "Ref: Gradient") style_file="$STYLES_DIR/ref-gradient.css"; config_file="${config_file:-$CONFIGS_DIR/ref-gradient.json}" ;;
  "Ref: Vertical") style_file="$STYLES_DIR/ref-vertical.css"; config_file="$CONFIGS_DIR/ref-vertical.json" ;;
  "Ref: Vertical Opaque") style_file="$STYLES_DIR/ref-vertical-opaque.css"; config_file="$CONFIGS_DIR/ref-vertical-opaque.json" ;;
  "Ref: Vertical Transparent") style_file="$STYLES_DIR/ref-vertical-transparent.css"; config_file="$CONFIGS_DIR/ref-vertical-transparent.json" ;;
  "Ref: Top Single Block") style_file="$STYLES_DIR/ref-top-single.css"; config_file="$CONFIGS_DIR/ref-top-single.json" ;;
  "Ref: Top Split Blocks") style_file="$STYLES_DIR/ref-top-split.css"; config_file="$CONFIGS_DIR/ref-top-split.json" ;;
  "Profile: Default (current)") style_file="$STYLES_DIR/matugen.css"; config_file="$CONFIGS_DIR/default.json" ;;
  "Profile: Cyberpunk Minimal (bottom)") style_file="$STYLES_DIR/cyberpunk.css"; config_file="$CONFIGS_DIR/minimal-bottom.json" ;;
  "Profile: Synthwave Split (center)") style_file="$STYLES_DIR/synthwave.css"; config_file="$CONFIGS_DIR/split-center.json" ;;
  "Profile: Neon Noir Dashboard") style_file="$STYLES_DIR/neon-noir.css"; config_file="$CONFIGS_DIR/dashboard-top.json" ;;
  "Profile: Aurora HUD (center)") style_file="$STYLES_DIR/aurora.css"; config_file="$CONFIGS_DIR/hud-center.json" ;;
  "Profile: Tactical Dock (left)") style_file="$STYLES_DIR/tactical.css"; config_file="$CONFIGS_DIR/left-dock.json" ;;
  "Profile: Mono Focus (top)") style_file="$STYLES_DIR/mono.css"; config_file="$CONFIGS_DIR/focus-top.json" ;;
  "Profile: Graphite Right Stack") style_file="$STYLES_DIR/graphite.css"; config_file="$CONFIGS_DIR/right-stack.json" ;;
  "Profile: Single Module (center)") style_file="$STYLES_DIR/holo.css"; config_file="$CONFIGS_DIR/single-module.json" ;;
  "Profile: Ultra Thin (top)") style_file="$STYLES_DIR/graphite.css"; config_file="$CONFIGS_DIR/ultra-thin-top.json" ;;
  "Profile: Top-Left Compact") style_file="$STYLES_DIR/mono.css"; config_file="$CONFIGS_DIR/top-left-compact.json" ;;
  "Profile: Right Dock") style_file="$STYLES_DIR/tactical.css"; config_file="$CONFIGS_DIR/right-dock.json" ;;
  *) exit 0 ;;
esac

if [ ! -f "$style_file" ]; then
  echo "Style not found: $style_file" >&2
  exit 1
fi

if [ -n "$config_file" ]; then
  if [ ! -f "$config_file" ]; then
    echo "Config not found: $config_file" >&2
    exit 1
  fi
  cp "$config_file" "$WAYBAR_DIR/config"
fi

cp "$style_file" "$WAYBAR_DIR/style.css"

pkill waybar || true
nohup waybar >/dev/null 2>&1 &
