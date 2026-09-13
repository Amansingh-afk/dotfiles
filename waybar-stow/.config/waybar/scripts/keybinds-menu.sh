#!/usr/bin/env bash
# Super+/ — searchable list of Hyprland keybinds, parsed live from keybinds.conf.
# Enter on a line runs it (exec lines run the command, others go through hyprctl dispatch).
conf="$HOME/.config/hypr/keybinds.conf"

rows=$(awk '
  /^\$mainMod/ { next }
  /^bind[elmr]* *=/ {
    line=$0; desc=""
    if (match(line, /#.*$/)) { desc=substr(line, RSTART+1); sub(/^ +/, "", desc); line=substr(line, 1, RSTART-1) }
    sub(/^bind[elmr]* *= */, "", line)
    n=split(line, f, ",")
    mods=f[1]; key=f[2]; disp=f[3]; args=""
    for (i=4;i<=n;i++) args=args (i>4?",":"") f[i]
    gsub(/^ +| +$/, "", mods); gsub(/^ +| +$/, "", key); gsub(/^ +| +$/, "", disp); gsub(/^ +| +$/, "", args)
    gsub(/\$mainMod/, "SUPER", mods); gsub(/ +/, "+", mods)
    combo=(mods=="" ? key : mods "+" key)
    gsub(/^SUPER\+SHIFT/, "SUPER+SHIFT", combo)
    if (desc=="") desc=disp (args!="" ? " " args : "")
    printf "%-22s %s\t%s\t%s\n", combo, desc, disp, args
  }' "$conf")

sel=$(printf '%s\n' "$rows" | cut -f1 | rofi -dmenu -i -p "keys" -config "$HOME/.config/rofi/menu.rasi") || exit 0
[[ -z "$sel" ]] && exit 0
line=$(printf '%s\n' "$rows" | grep -F -m1 "$sel")
disp=$(printf '%s' "$line" | cut -f2); args=$(printf '%s' "$line" | cut -f3)
if [[ "$disp" == "exec" ]]; then
  args=${args//\$scripts/$HOME/.config/waybar/scripts}
  args=${args//\$terminal/kitty}; args=${args//\$fileManager/kitty yazi}
  args=${args//\$menu/$HOME/.config/waybar/scripts/app-launcher.sh}
  setsid -f bash -c "$args" >/dev/null 2>&1
else
  hyprctl dispatch "$disp" "$args" >/dev/null
fi
