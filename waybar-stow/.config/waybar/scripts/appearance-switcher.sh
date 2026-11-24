#!/usr/bin/env bash
# Appearance switcher — themes and wallpapers in one rofi card grid.
#
# Runs in two roles:
#   1. Launcher (no ROFI_RETV in env):  appearance-switcher.sh [themes|walls] | toggle | --gen
#      Generates missing preview cards, then opens rofi with two script modes (tabs) that all
#      point back at this file: "Themes", "Wallpapers". Ctrl+Tab or click switches tabs.
#   2. Rofi script mode (ROFI_RETV set, $1 = page): prints the rows of that page; rofi calls us
#      again with ROFI_INFO="<cmd>:<arg>" when a card is picked. Everything stays in one window.
#
# Preview cards (500x500 PNG) are cached in ~/.cache/appearance-switcher/ and rebuilt when
# their source changes.

set -uo pipefail

SELF=$(readlink -f "${BASH_SOURCE[0]}")
WB="$HOME/.config/waybar"
WB_THEMES="$WB/themes"
KITTY_THEMES="$HOME/.config/kitty/themes"
RASI="$HOME/.config/rofi/appearance.rasi"
CACHE="$HOME/.cache/appearance-switcher"
FONT="JetBrainsMono-NF-Bold"

WALL_DIR_DEFAULT="$HOME/realm/builds/dotfiles/wallpapers"
WALL_DIR_ALT="$HOME/Pictures/Wallpapers"
if [[ -d "$WALL_DIR_DEFAULT" ]]; then WALL_DIR="$WALL_DIR_DEFAULT"
elif [[ -d "$WALL_DIR_ALT" ]]; then WALL_DIR="$WALL_DIR_ALT"
else WALL_DIR=""; fi
CURRENT_WALL_LINK="$WALL_DIR_DEFAULT/current"

# ──────────────────────────────────────────── state ────────────────────────────────────────────

list_themes()  { ls -1 "$WB_THEMES"/*.css 2>/dev/null | xargs -n1 basename | sed 's/\.css$//' | grep -v '^current$'; }
list_walls()   { [[ -n "$WALL_DIR" ]] && find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort; }

current_theme()  { [[ -L "$WB_THEMES/current.css" ]] && basename "$(readlink "$WB_THEMES/current.css")" .css || echo unknown; }
current_wall()   { [[ -L "$CURRENT_WALL_LINK" ]] && readlink -f "$CURRENT_WALL_LINK" || echo ""; }

# ─────────────────────────────────────── preview cards ─────────────────────────────────────────

# Value from a kitty theme file: kitty_get <file> <key>
kitty_get() { awk -v key="$2" '$1 == key { print $2; exit }' "$1"; }

# Theme card: terminal mockup + palette swatches, from the kitty theme file.
gen_theme_card() {
  local theme="$1" out="$2" conf="$KITTY_THEMES/$1.conf"
  local bg fg i x
  bg=$(kitty_get "$conf" background); fg=$(kitty_get "$conf" foreground)
  [[ -z "$bg" || -z "$fg" ]] && { bg="#282828"; fg="#ebdbb2"; }
  local -a n=() br=()
  for i in 1 2 3 4 5 6; do
    n+=("$(kitty_get "$conf" color$i)"); br+=("$(kitty_get "$conf" color$((i+8)))")
  done
  local -a a=(-size 500x500 "xc:$bg")
  # terminal window
  a+=(-fill "${fg}" -draw "roundrectangle 40,60 460,330 16,16" -fill "$bg" -draw "roundrectangle 44,64 456,326 14,14")
  a+=(-fill "${n[0]}" -draw "circle 68,88 68,97" -fill "${n[2]}" -draw "circle 96,88 96,97" -fill "${n[1]}" -draw "circle 124,88 124,97")
  # prompt lines
  a+=(-fill "${n[3]}" -draw "roundrectangle 66,124 190,140 6,6" -fill "$fg" -draw "roundrectangle 200,124 350,140 6,6")
  a+=(-fill "${n[4]}" -draw "roundrectangle 66,154 130,170 6,6" -fill "$fg" -draw "roundrectangle 140,154 420,170 6,6")
  a+=(-fill "${n[1]}" -draw "roundrectangle 66,184 160,200 6,6" -fill "$fg" -draw "roundrectangle 170,184 300,200 6,6")
  a+=(-fill "${n[2]}" -draw "roundrectangle 66,214 110,230 6,6" -fill "$fg" -draw "roundrectangle 120,214 380,230 6,6")
  a+=(-fill "${n[5]}" -draw "roundrectangle 66,244 240,260 6,6" -fill "$fg" -draw "roundrectangle 250,244 330,260 6,6")
  a+=(-fill "$fg" -draw "roundrectangle 66,278 82,296 3,3")
  # swatches: normal row + bright row
  x=40
  for i in 0 1 2 3 4 5; do
    a+=(-fill "${n[$i]:-$fg}" -draw "roundrectangle $x,360 $((x+62)),410 10,10")
    a+=(-fill "${br[$i]:-$fg}" -draw "roundrectangle $x,420 $((x+62)),446 8,8")
    x=$((x+72))
  done
  magick "${a[@]}" "$out" 2>/dev/null
}

# Wallpaper card: blurred cover backdrop + sharp 16:9 inset.
gen_wall_card() {
  local src="$1" out="$2"
  magick \( "$src" -resize 500x500^ -gravity center -extent 500x500 -scale 12% -blur 0x2 -resize 500x500! -modulate 55,90 \) \
         \( "$src" -resize 452x254^ -gravity center -extent 452x254 -bordercolor '#ffffffcc' -border 2 \) \
         -gravity center -composite "$out" 2>/dev/null
}

# Random card: darkened 2x2 mosaic of wallpapers with a big "?".
gen_random_card() {
  local out="$1"; local -a w
  mapfile -t w < <(list_walls | shuf -n4)
  tile() { printf '%s\n' "(" "$1" -resize 250x250^ -gravity center -extent 250x250 ")"; }
  if (( ${#w[@]} == 4 )); then
    local -a r1 r2
    mapfile -t r1 < <(tile "${w[0]}"; tile "${w[1]}")
    mapfile -t r2 < <(tile "${w[2]}"; tile "${w[3]}")
    magick "(" "${r1[@]}" +append ")" "(" "${r2[@]}" +append ")" -append \
      -modulate 45,70 -gravity center -font "$FONT" -pointsize 220 -fill '#ffffffee' -annotate +0+0 "?" "$out" 2>/dev/null && return
  fi
  magick -size 500x500 gradient:'#504945-#1d2021' -gravity center -font "$FONT" -pointsize 220 -fill '#ffffffee' -annotate +0+0 "?" "$out"
}

stale() { [[ ! -f "$1" || "$2" -nt "$1" ]]; }   # stale <target> <source>

wall_card_path() { echo "$CACHE/walls/$(basename "${1%.*}").png"; }

ensure_previews() {
  mkdir -p "$CACHE/themes" "$CACHE/walls"
  local t w out first=1
  for t in $(list_themes); do
    out="$CACHE/themes/$t.png"
    if stale "$out" "$KITTY_THEMES/$t.conf" || stale "$out" "$SELF"; then gen_theme_card "$t" "$out"; fi
  done
  while IFS= read -r w; do
    [[ -z "$w" ]] && continue
    out=$(wall_card_path "$w")
    if stale "$out" "$w"; then
      (( first )) && { notify-send "󰏘 Appearance" "Generating wallpaper previews…" -t 3000 2>/dev/null; first=0; }
      gen_wall_card "$w" "$out"
    fi
  done < <(list_walls)
  if stale "$CACHE/random.png" "$SELF" || [[ -n "$WALL_DIR" && "$WALL_DIR" -nt "$CACHE/random.png" ]]; then gen_random_card "$CACHE/random.png"; fi
}

# ──────────────────────────────────────────── apply ────────────────────────────────────────────

# Fast, synchronous part first so the re-rendered menu shows the new state; slow bits go
# to the background with all fds closed so rofi is not blocked.
apply_theme() {
  local theme="$1"
  "$WB/scripts/theme-apply.sh" "$theme"
  (
    pkill -x waybar; sleep 0.3; setsid -f waybar
    makoctl reload
    notify-send "󰏘 Theme" "$theme" -t 2000
  ) >/dev/null 2>&1 </dev/null &
  disown
}

apply_wall() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  ln -sfn "$file" "$CURRENT_WALL_LINK" 2>/dev/null || true
  (
    pgrep -x hyprpaper >/dev/null || { setsid -f hyprpaper; sleep 1; }
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$file"
    for m in $(hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p'); do
      hyprctl hyprpaper wallpaper "$m,$file"
    done
    notify-send "󰸉 Wallpaper" "$(basename "$file")" -t 2000
  ) >/dev/null 2>&1 </dev/null &
  disown
}

random_wall() {
  local cur pick
  cur=$(current_wall)
  pick=$(list_walls | grep -vxF "$cur" | shuf -n1)
  [[ -z "$pick" ]] && pick=$(list_walls | shuf -n1)
  [[ -n "$pick" ]] && apply_wall "$pick"
}

# ───────────────────────────────────────── rofi output ─────────────────────────────────────────

row() {  # row <text> <icon> <info> [active]
  printf '%s\0icon\x1f%s\x1finfo\x1f%s\x1factive\x1f%s\n' "$1" "$2" "$3" "${4:-false}"
}

header() {  # header <menu> <prompt> [message]
  printf '\0data\x1f%s\n' "$1"
  printf '\0prompt\x1f%s\n' "$2"
  printf '\0markup-rows\x1ftrue\n'
  printf '\0no-custom\x1ftrue\n'
  printf '\0message\x1f%s\n' "${3:-}"
}

menu_themes() {
  local cur t
  cur=$(current_theme)
  header themes "󰏘  Themes" "<span alpha='70%'>Colour theme · applies to kitty, rofi, waybar, hyprland, mako, gtk, nvim, zsh · current: <b>$cur</b></span>"
  for t in $(list_themes); do
    if [[ "$t" == "$cur" ]]; then row "󰸞  $t" "$CACHE/themes/$t.png" "theme:$t" true
    else row "$t" "$CACHE/themes/$t.png" "theme:$t"; fi
  done
}

menu_walls() {
  local cur w name
  cur=$(current_wall)
  header walls "󰸉  Wallpapers" "<span alpha='70%'>$WALL_DIR · current: <b>$( [[ -n "$cur" ]] && basename "${cur%.*}" || echo none )</b></span>"
  row "󰒲  Random" "$CACHE/random.png" "random:"
  while IFS= read -r w; do
    [[ -z "$w" ]] && continue
    name=$(basename "${w%.*}")
    if [[ "$(readlink -f "$w")" == "$cur" ]]; then row "󰸞  $name" "$(wall_card_path "$w")" "wall:$w" true
    else row "$name" "$(wall_card_path "$w")" "wall:$w"; fi
  done < <(list_walls)
}

show_menu() {
  case "$1" in
    walls)   menu_walls ;;
    *)       menu_themes ;;
  esac
}

# ────────────────────────────────────────── entrypoint ─────────────────────────────────────────

if [[ -z "${ROFI_RETV:-}" ]]; then
  # Launcher role
  if [[ "${1:-}" == "--gen" ]]; then ensure_previews; exit 0; fi   # only (re)build preview cards
  if [[ "${1:-}" == "toggle" ]]; then   # flip between the two themes, no menu
    [[ "$(current_theme)" == "gruvbox" ]] && apply_theme monochrome || apply_theme gruvbox
    exit 0
  fi
  ensure_previews
  case "${1:-themes}" in
    walls|wallpapers) start="Wallpapers" ;;
    *) start="Themes" ;;
  esac
  exec rofi -show "$start" \
    -modes "Themes:$SELF themes,Wallpapers:$SELF walls" \
    -theme "$RASI"
fi

# Script-mode role: $1 = page, ROFI_INFO = "<cmd>:<arg>" of the picked card
page="${1:-themes}"
case "${ROFI_RETV}" in
  1)
    cmd="${ROFI_INFO%%:*}"; arg="${ROFI_INFO#*:}"
    printf '\0keep-selection\x1ftrue\n'
    case "$cmd" in
      theme)  apply_theme "$arg" ;;
      wall)   apply_wall "$arg" ;;
      random) random_wall ;;
    esac
    show_menu "$page"
    ;;
  *) show_menu "$page" ;;
esac
