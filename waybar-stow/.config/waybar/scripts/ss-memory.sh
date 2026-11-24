#!/usr/bin/env bash
# Used-memory readout for waybar (htop-style accounting).
# Ported from https://github.com/el-toro-fuerte96/swaystation

while read -r key value _; do
  case "$key" in
    MemTotal:)         total=$value ;;
    MemFree:)          free=$value ;;
    "Active(file):")   active_file=$value ;;
    "Inactive(file):") inactive_file=$value ;;
    SReclaimable:)     sreclaimable=$value ;;
  esac
done < /proc/meminfo

used=$(( total - (free + active_file + inactive_file + sreclaimable) ))

if (( used < 1048576 )); then
  mem_str="$(( used / 1024 ))MiB"
else
  mem_str="$(awk -v val="$used" 'BEGIN {printf "%.1fGiB", val/1048576}')"
fi

printf '{"text":"%s"}\n' "$mem_str"
