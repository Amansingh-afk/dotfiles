#!/usr/bin/env bash
# Super+Shift+/ — pick a cheat sheet in rofi, read it in a floating terminal (same as `cheat <topic>`).
dir="$HOME/.config/cheats"
topic=$(ls "$dir" | sed 's/\.md$//' | rofi -dmenu -i -p "cheat" -config "$HOME/.config/rofi/menu.rasi" -theme-str "listview { lines: 8; } window { width: 360px; }") || exit 0
[[ -z "$topic" ]] && exit 0
setsid -f kitty --class tui-float zsh -ic "cheat $topic" >/dev/null 2>&1
