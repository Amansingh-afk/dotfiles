#!/bin/bash

entries="⇠ Logout\n⭮ Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | rofi -dmenu -i -p "Power Menu" -lines 3)

case $selected in
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
