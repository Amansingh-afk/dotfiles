#!/usr/bin/env bash
# wallpaper.sh — wallpaper picker (rofi card grid). "wallpaper.sh random" sets a random one.
# Runs as launcher, and again as rofi script mode (ROFI_RETV set) when a card is picked.
set -uo pipefail

SELF=$(readlink -f "${BASH_SOURCE[0]}")
RASI="$HOME/.config/rofi/wallpaper.rasi"
CACHE="$HOME/.cache/wallpaper-cards"
WALL_DIR="$(cd "$(dirname "$SELF")/../../../.." && pwd)/wallpapers"
CURRENT="$WALL_DIR/current"

list_walls()   { find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort; }
current_wall() { [[ -L "$CURRENT" ]] && readlink -f "$CURRENT" || echo ""; }
card_path()    { echo "$CACHE/$(basename "${1%.*}").png"; }

# Card: blurred cover backdrop + sharp 16:9 inset
gen_card() {
  magick \( "$1" -resize 500x500^ -gravity center -extent 500x500 -scale 12% -blur 0x2 -resize 500x500! -modulate 55,90 \) \
         \( "$1" -resize 452x254^ -gravity center -extent 452x254 -bordercolor '#ffffffcc' -border 2 \) \
         -gravity center -composite "$2" 2>/dev/null
}

ensure_cards() {
  mkdir -p "$CACHE"
  local w out
  while IFS= read -r w; do
    out=$(card_path "$w")
    if [[ ! -f "$out" || "$w" -nt "$out" ]]; then gen_card "$w" "$out"; fi
  done < <(list_walls)
}

apply_wall() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  ln -sfn "$(basename "$file")" "$CURRENT"
  (
    pgrep -x hyprpaper >/dev/null || { setsid -f hyprpaper; sleep 1; }
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$file"
    for m in $(hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p'); do
      hyprctl hyprpaper wallpaper "$m,$file"
    done
  ) >/dev/null 2>&1 </dev/null &
  disown
}

menu() {
  local cur w name mark active
  cur=$(current_wall)
  printf '\0prompt\x1f󰸉  Wallpapers\n\0no-custom\x1ftrue\n'
  while IFS= read -r w; do
    name=$(basename "${w%.*}"); mark=""; active=false
    [[ "$w" == "$cur" ]] && { mark="󰸞  "; active=true; }
    printf '%s\0icon\x1f%s\x1finfo\x1f%s\x1factive\x1f%s\n' "$mark$name" "$(card_path "$w")" "$w" "$active"
  done < <(list_walls)
}

if [[ -n "${ROFI_RETV:-}" ]]; then
  if [[ "$ROFI_RETV" == 1 ]]; then
    printf '\0keep-selection\x1ftrue\n'
    apply_wall "$ROFI_INFO"
  fi
  menu
elif [[ "${1:-}" == random ]]; then
  pick=$(list_walls | grep -vxF "$(current_wall)" | shuf -n1)
  [[ -n "$pick" ]] && apply_wall "$pick"
else
  ensure_cards
  exec rofi -show Wallpapers -modes "Wallpapers:$SELF" -theme "$RASI"
fi
