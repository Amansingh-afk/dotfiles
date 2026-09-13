#!/usr/bin/env bash
# screenrecord.sh [region|full] — toggle: first call starts wf-recorder, second call stops it.
# Bound to Super+Alt+Print (region) and Super+Alt+Shift+Print (full). Saves to ~/Videos/Recordings.
set -uo pipefail

if pgrep -x wf-recorder >/dev/null; then
  pkill -INT -x wf-recorder
  sleep 0.5
  last=$(ls -t "$HOME/Videos/Recordings"/*.mp4 2>/dev/null | head -1)
  notify-send "Recording saved" "${last:-?}" -t 4000
  pkill -RTMIN+8 waybar 2>/dev/null || true
  exit 0
fi

mode="${1:-region}"
dir="$HOME/Videos/Recordings"
mkdir -p "$dir"
file="$dir/rec-$(date +%Y%m%d_%H%M%S).mp4"

args=(-f "$file" --audio)
if [[ "$mode" == "region" ]]; then
  geom=$(slurp) || exit 0
  args+=(-g "$geom")
fi

notify-send "Recording started" "$mode, same key stops" -t 2000
pkill -RTMIN+8 waybar 2>/dev/null || true
exec wf-recorder "${args[@]}" >/dev/null 2>&1
