#!/usr/bin/env bash
# screenshot.sh region|full|window — save to ~/Pictures/Screenshots and copy to clipboard.
# Bound to Print / Shift+Print / Ctrl+Print in keybinds.conf.
set -euo pipefail

mode="${1:-region}"
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/screenshot-$(date +%Y%m%d_%H%M%S).png"

args=()
case "$mode" in
  region)
    geom=$(slurp) || exit 0            # Esc cancels
    args=(-g "$geom") ;;
  full)
    ;;
  window)
    geom=$(hyprctl activewindow -j | jq -r 'select(.at) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    [[ -z "$geom" ]] && exit 0
    args=(-g "$geom") ;;
  *)
    echo "usage: $0 region|full|window" >&2; exit 1 ;;
esac

grim "${args[@]}" - | tee "$file" | wl-copy
notify-send -i "$file" "Screenshot $mode" "$file" -t 3000
