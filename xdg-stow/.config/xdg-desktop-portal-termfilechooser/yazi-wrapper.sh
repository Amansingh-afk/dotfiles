#!/usr/bin/env bash
# Called by xdg-desktop-portal-termfilechooser:
#   $1 multiple (0/1)  $2 directory (0/1)  $3 save (0/1)  $4 suggested path  $5 output file
multiple="$1"; directory="$2"; save="$3"; path="$4"; out="$5"
termcmd="${TERMCMD:-kitty --class tui-float}"

if [[ "$save" == "1" ]]; then
  # Save dialog: yazi picks an existing file; create the suggested one so it can be picked.
  [[ -n "$path" && ! -e "$path" ]] && { mkdir -p "$(dirname "$path")"; : > "$path"; created="$path"; }
  $termcmd yazi --chooser-file="$out" "$(dirname "$path")"
  # nothing chosen -> remove the placeholder
  [[ -n "$created" && ! -s "$out" ]] && rm -f "$created"
elif [[ "$directory" == "1" ]]; then
  # Directory dialog: quit yazi (q) inside the wanted directory.
  $termcmd yazi --cwd-file="$out" "${path:-$HOME}"
else
  # Open dialog: Enter on a file (or select several with Space, then Enter).
  $termcmd yazi --chooser-file="$out" "${path:-$HOME}"
fi
