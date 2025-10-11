#!/usr/bin/env bash

set -euo pipefail

# Discover wallpapers directory
WALL_DIR_DEFAULT="$HOME/realm/builds/dotfiles/wallpapers"
WALL_DIR_ALT="$HOME/Pictures/Wallpapers"
CURRENT_LINK="$WALL_DIR_DEFAULT/current"

if [ -d "$WALL_DIR_DEFAULT" ]; then
  WALL_DIR="$WALL_DIR_DEFAULT"
elif [ -d "$WALL_DIR_ALT" ]; then
  WALL_DIR="$WALL_DIR_ALT"
else
  notify-send -a "Wallpaper" "No wallpapers directory found" "Expected $WALL_DIR_DEFAULT or $WALL_DIR_ALT"
  exit 1
fi

mapfile -t FILES < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ ${#FILES[@]} -eq 0 ]; then
  notify-send -a "Wallpaper" "No images found in $WALL_DIR"
  exit 0
fi

# Build rofi input with icons and keep an indexable array
build_rofi_list() {
  local i=0
  for f in "${FILES[@]}"; do
    local base
    base="$(basename "$f")"
    # label with icon preview
    printf '%s\0icon\x1f%s\n' "$base" "$f"
    ((i++))
  done
}

# Choose via rofi (index-based so we can map back to FILES)
SELECTION_INDEX=$(build_rofi_list | rofi -dmenu -i -p "Wallpaper" -show-icons -format i -theme "$HOME/.config/rofi/themes/current.rasi")

if [ -z "${SELECTION_INDEX}" ] || [ "$SELECTION_INDEX" = "-1" ]; then
  exit 0
fi

SEL_FILE="${FILES[$SELECTION_INDEX]}"

# Apply wallpaper using hyprpaper IPC for all monitors
if ! hyprctl hyprpaper ls >/dev/null 2>&1; then
  notify-send -a "Wallpaper" "hyprpaper IPC not available" "Ensure ipc = on in hyprpaper.conf and hyprpaper is running"
  exit 1
fi

hyprctl hyprpaper preload "$SEL_FILE" >/dev/null 2>&1 || true

# Get monitor names
mapfile -t MONS < <(hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p')

if [ ${#MONS[@]} -eq 0 ]; then
  notify-send -a "Wallpaper" "No monitors detected"
  exit 1
fi

for m in "${MONS[@]}"; do
  hyprctl hyprpaper wallpaper "$m,$SEL_FILE" >/dev/null 2>&1 || true
done

notify-send -a "Wallpaper" "Set wallpaper" "$(basename "$SEL_FILE")"

# Persist selection for next session (update current symlink)
mkdir -p "$WALL_DIR_DEFAULT"
ln -sfn "$SEL_FILE" "$CURRENT_LINK"

exit 0


