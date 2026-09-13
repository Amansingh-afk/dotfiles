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
  # Directory dialog: Enter on a directory, or quit yazi (q) inside it.
  $termcmd yazi --chooser-file="$out" --cwd-file="$out.1" "${path:-$HOME}"
  if [[ ! -s "$out" && -s "$out.1" ]]; then cat "$out.1" > "$out"; fi
  rm -f "$out.1"
else
  # Open dialog: Enter on a file (or select several with Space, then Enter).
  $termcmd yazi --chooser-file="$out" "${path:-$HOME}"
fi
