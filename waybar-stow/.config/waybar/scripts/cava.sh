#!/bin/bash

# Function to convert a number to a bar character
bar_character() {
    local num=$1
    case $num in
        0) echo "▁";;
        1) echo "▂";;
        2) echo "▃";;
        3) echo "▄";;
        4) echo "▅";;
        5) echo "▆";;
        6) echo "▇";;
        7|8|9) echo "█";;
    esac
}

# Ensure the script continues running even if cava temporarily fails
while true; do
    cava -p /home/dmann/.config/cava/config | while read -r line; do
        # Convert the raw cava output into a visualization
        bars=""
        for num in $(echo "$line" | tr ';' ' '); do
            bars="$bars$(bar_character $num)"
        done
        
        # Only output if we actually have bars
        if [ ! -z "$bars" ]; then
            echo "{\"text\": \"$bars\", \"class\": \"music\"}"
        fi
    done
    sleep 1
done
