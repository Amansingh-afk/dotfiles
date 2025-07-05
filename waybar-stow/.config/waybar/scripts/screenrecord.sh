#!/bin/bash

RECORDING_PID_FILE="/tmp/recording.pid"
RECORDING_DIR="$HOME/Videos/Recordings"
mkdir -p "$RECORDING_DIR"

status() {
    if [[ -f "$RECORDING_PID_FILE" ]]; then
        echo '{"text": "󰻃", "class": "recording", "tooltip": "Recording in progress - Click to stop"}'
    else
        echo '{"text": "󰻃", "tooltip": "Click to start recording"}'
    fi
}

start_recording() {
    filename="$RECORDING_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"
    wf-recorder -f "$filename" &
    echo $! > "$RECORDING_PID_FILE"
    notify-send "Recording Started" "Recording to $filename"
}

stop_recording() {
    if [[ -f "$RECORDING_PID_FILE" ]]; then
        pid=$(cat "$RECORDING_PID_FILE")
        kill -SIGINT "$pid"
        rm "$RECORDING_PID_FILE"
        notify-send "Recording Stopped" "Saved to $RECORDING_DIR"
    fi
}

toggle() {
    if [[ -f "$RECORDING_PID_FILE" ]]; then
        stop_recording
    else
        start_recording
    fi
}

case "$1" in
    "status")
        status
        ;;
    "toggle")
        toggle
        ;;
    "stop")
        stop_recording
        ;;
esac 