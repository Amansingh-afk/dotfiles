#!/usr/bin/env bash
# Super+Shift+V — clipboard history (cliphist) in rofi, Enter copies the entry back.
cliphist list | rofi -dmenu -i -p "clip" -config "$HOME/.config/rofi/menu.rasi" | cliphist decode | wl-copy
