#!/usr/bin/env bash
# Super+Shift+V — clipboard history (cliphist) in rofi, Enter copies the entry back.
cliphist list | rofi -dmenu -i -p "clip" -config "$HOME/.config/rofi/power-menu.rasi" -theme-str 'window { width: 50%; } listview { lines: 12; }' | cliphist decode | wl-copy
