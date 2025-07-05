#!/usr/bin/env bash

# Original script by Eric Murphy
# https://github.com/ericmurphyxyz/dotfiles/blob/master/.local/bin/battery-alert
#
# Modified by Jesse Mirabel (@sejjy)
# https://github.com/sejjy/mechabar

# This script sends a notification when the battery is full, low, or critical.
# icon theme used: tela-circle-icon-theme-dracula
#
# (see the bottom of the script for more information)

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# battery levels
WARNING_LEVEL=20
CRITICAL_LEVEL=10

# get the battery state and percentage using upower
BAT_PATH=$(upower -e | grep BAT | head -n 1)
BATTERY_STATE=$(upower -i "$BAT_PATH" | awk '/state:/ {print $2}')
BATTERY_LEVEL=$(upower -i "$BAT_PATH" | awk '/percentage:/ {print $2}' | tr -d '%')

# prevent multiple notifications
FILE_FULL=/tmp/battery-full
FILE_WARNING=/tmp/battery-warning
FILE_CRITICAL=/tmp/battery-critical

# remove the files if the battery is no longer in that state
if [ "$BATTERY_STATE" == "discharging" ]; then
  rm -f $FILE_FULL
elif [ "$BATTERY_STATE" == "charging" ]; then
  rm -f "$FILE_WARNING" "$FILE_CRITICAL"
fi

# Handle notifications
if [ "$BATTERY_LEVEL" -eq 100 ] && [ "$BATTERY_STATE" == "fully-charged" ] && [ ! -f $FILE_FULL ]; then
  notify-send -a "state" "Battery Charged (${BATTERY_LEVEL}%)" "You might want to unplug your PC." -i "battery-full" -r 9991
  touch $FILE_FULL
elif [ "$BATTERY_LEVEL" -le $WARNING_LEVEL ] && [ "$BATTERY_STATE" == "discharging" ] && [ ! -f $FILE_WARNING ]; then
  notify-send -a "state" "Battery Low (${BATTERY_LEVEL}%)" "You might want to plug in your PC." -u critical -i "battery-caution" -r 9991
  touch $FILE_WARNING
elif [ "$BATTERY_LEVEL" -le $CRITICAL_LEVEL ] && [ "$BATTERY_STATE" == "discharging" ] && [ ! -f $FILE_CRITICAL ]; then
  notify-send -a "state" "Battery Critical (${BATTERY_LEVEL}%)" "Plug in your PC now." -u critical -i "battery-empty" -r 9991
  touch $FILE_CRITICAL
fi

# Set icon based on battery state and level
if [ "$BATTERY_STATE" == "charging" ]; then
    ICON="󰂄"
elif [ "$BATTERY_LEVEL" -ge 90 ]; then
    ICON="󰁹"
elif [ "$BATTERY_LEVEL" -ge 80 ]; then
    ICON="󰂂"
elif [ "$BATTERY_LEVEL" -ge 70 ]; then
    ICON="󰂁"
elif [ "$BATTERY_LEVEL" -ge 60 ]; then
    ICON="󰂀"
elif [ "$BATTERY_LEVEL" -ge 50 ]; then
    ICON="󰁿"
elif [ "$BATTERY_LEVEL" -ge 40 ]; then
    ICON="󰁾"
elif [ "$BATTERY_LEVEL" -ge 30 ]; then
    ICON="󰁽"
elif [ "$BATTERY_LEVEL" -ge 20 ]; then
    ICON="󰁼"
elif [ "$BATTERY_LEVEL" -ge 10 ]; then
    ICON="󰁻"
else
    ICON="󰁺"
fi

# Output JSON for Waybar
if [ "$BATTERY_STATE" == "charging" ]; then
    echo "{\"icon\": \"󰂄\", \"tooltip\": \"<span font='JetBrainsMono Nerd Font 11'><b><span color='#ebdbb2'>${BATTERY_LEVEL}%</span> <span color='#ebdbb2'>(Charging)</span></b></span>\", \"class\": \"$BATTERY_STATE\", \"percentage\": $BATTERY_LEVEL}"
elif [ "$BATTERY_STATE" == "fully-charged" ]; then
    echo "{\"icon\": \"󰚥\", \"tooltip\": \"<span font='JetBrainsMono Nerd Font 11'><span color='#ebdbb2'>${BATTERY_LEVEL}%</span> <span color='#ebdbb2'>(Plugged)</span></span>\", \"class\": \"$BATTERY_STATE\", \"percentage\": $BATTERY_LEVEL}"
else
    echo "{\"icon\": \"$ICON\", \"tooltip\": \"<span font='JetBrainsMono Nerd Font 11'><span color='#ebdbb2'>${BATTERY_LEVEL}%</span></span>\", \"class\": \"$BATTERY_STATE\", \"percentage\": $BATTERY_LEVEL}"
fi

# systemd service
# Add the following to ~/.config/systemd/user/battery-level.service:

# [Unit]
# Description=Battery Level Checker
# After=graphical.target
#
# [Service]
# ExecStart=%h/.config/waybar/scripts/battery-level.sh
# Type=oneshot

# systemd timer
# Add the following to ~/.config/systemd/user/battery-level.timer:

# [Unit]
# Description=Run Battery Level Checker
#
# [Timer]
# OnBootSec=1min
# OnUnitActiveSec=1min
# Unit=battery-level.service
#
# [Install]
# WantedBy=timers.target

# enable the timer by running the following commands:
# systemctl --user daemon-reload
# systemctl --user enable --now battery-level.timer
