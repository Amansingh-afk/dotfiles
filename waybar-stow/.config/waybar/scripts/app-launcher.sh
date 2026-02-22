#!/usr/bin/env bash

# App Launcher - Stunning rofi application menu
# Uses drun mode with beautiful grid layout

config="$HOME/.config/rofi/app-launcher.rasi"

# Launch rofi in drun mode (shows .desktop applications)
# -no-drun-show-actions: prevents duplicate entries from app actions
# -drun-display-format: shows only name to avoid visual duplicates
# -drun-match-fields: search across name, generic name, and categories
rofi -show drun \
    -config "$config" \
    -drun-display-format "{name}" \
    -drun-match-fields name,generic,categories \
    -no-drun-show-actions \
    -terminal alacritty \
    -sort \
    -sorting-method fzf \
    -matching fuzzy \
    -steal-focus
