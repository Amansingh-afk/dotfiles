#!/bin/bash

config="$HOME/.config/rofi/power-menu.rasi"

entries=" Lock\n⇠ Logout\n⭮ Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | rofi -dmenu -i -config "${config}")

case $selected in
    " Lock")
        hyprlock
        ;;
    "⇠ Logout")
        hyprctl dispatch exit
        ;;
    "⭮ Reboot")
        systemctl reboot
        ;;
    "⏻ Shutdown")
        systemctl poweroff
        ;;
esac
