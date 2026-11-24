#!/usr/bin/env bash
# CPU package temperature for the swaystation waybar layouts.
# Reads hwmon/thermal sysfs directly (no lm_sensors dependency).
# Usage: ss-cpu-temp.sh [block|flat]   (icon style, matches the layout's other modules)

style="${1:-block}"

read_temp() {
  local h name f
  # Preferred: coretemp (Intel) / k10temp, zenpower (AMD) package sensor
  for h in /sys/class/hwmon/hwmon*; do
    name=$(<"$h/name") 2>/dev/null || continue
    case "$name" in
      coretemp|k10temp|zenpower)
        f="$h/temp1_input"
        [[ -r "$f" ]] && { cat "$f"; return 0; }
        ;;
    esac
  done
  # Fallback: thermal zones commonly exposing the package temp
  local z
  for z in /sys/class/thermal/thermal_zone*; do
    case "$(<"$z/type")" in
      x86_pkg_temp|TCPU|cpu-thermal|cpu_thermal)
        [[ -r "$z/temp" ]] && { cat "$z/temp"; return 0; }
        ;;
    esac
  done
  return 1
}

[[ "${2:-}" == mono ]] && mono=1 || mono=""

icon_span() {  # $1 = icon, $2 = colour, $3 = text
  [[ -n "$mono" ]] && set -- "$1" "#e6e6e6" "$3"
  case "$style" in
    flat)    printf "<span color='%s' > %s </span>%s" "$2" "$1" "$3" ;;
    *)       printf "<span color='#202020' bgcolor='%s' > %s </span> %s" "$2" "$1" "$3" ;;
  esac
}

if ! raw=$(read_temp) || [[ -z "$raw" ]]; then
  text=$(icon_span "" "#555555" "N/A°C")
  printf '{"text":"%s","class":"unknown"}\n' "$text"
  exit 0
fi

temp=$(( raw / 1000 ))

if (( temp >= 70 )); then
  text=$(icon_span "" "#cc241d" "${temp}°C")
  printf '{"text":"%s","class":"critical"}\n' "$text"
else
  text=$(icon_span "󰴈" "#d8a657" "${temp}°C")
  printf '{"text":"%s","class":"normal"}\n' "$text"
fi
