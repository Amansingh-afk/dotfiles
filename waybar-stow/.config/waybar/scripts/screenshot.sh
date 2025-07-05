#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

if [[ "$1" == "--area" ]]; then
    # Direct area screenshot
    grimblast copy area
    exit 0
fi

# Show screenshot menu
selected=$(echo -e "󰹑 Full Screen\n󰆞 Select Area\n󰨇 Active Window\n---\n󰆏 Save to File" | rofi -dmenu -p "Screenshot" -theme "~/.config/rofi/base.rasi")

case "$selected" in
    "󰹑 Full Screen")
        grimblast copy output
        ;;
    "󰆞 Select Area")
        grimblast copy area
        ;;
    "󰨇 Active Window")
        grimblast copy active
        ;;
    "󰆏 Save to File")
        filename="$SCREENSHOT_DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"
        grimblast save output "$filename"
        notify-send "Screenshot Saved" "Saved to $filename"
        ;;
esac 