# Place your custom Zsh functions here
lfcd () {
  tmpfile=$(mktemp)
  lf -selection-path="$tmpfile"
  [ -s "$tmpfile" ] && nvim $(<"$tmpfile")
  rm -f "$tmpfile"
}

