#!/usr/bin/env bash
# CPU package temperature for waybar. Icon and colour per state live in config.in.
# Reads hwmon/thermal sysfs directly (no lm_sensors dependency).

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

if ! raw=$(read_temp) || [[ -z "$raw" ]]; then
  echo '{"text":"N/A°C","alt":"unknown","class":"unknown"}'
  exit 0
fi

temp=$(( raw / 1000 ))
state=normal
(( temp >= 70 )) && state=critical
printf '{"text":"%s°C","alt":"%s","class":"%s"}\n' "$temp" "$state" "$state"
