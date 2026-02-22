#!/bin/bash

config="$HOME/.config/rofi/power-menu.rasi"

options="󰌾  Lock\n󰗽  Logout\n󰤄  Sleep\n󰜉  Reboot\n󰐥  Power off"

selected=$(echo -e "$options" | rofi -dmenu -i -config "$config")

case "$selected" in
    *"Lock"*)     hyprlock ;;
    *"Logout"*)   hyprctl dispatch exit ;;
    *"Sleep"*)    systemctl suspend ;;
    *"Reboot"*)   systemctl reboot ;;
    *"Power"*)    systemctl poweroff ;;
esac
