# Custom Zsh functions

# yazi: cd to the directory you were in when quitting
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# cheat [topic]     read a cheat sheet (~/.config/cheats/*.md) in glow; no topic = fzf picker
# cheat -e [topic]  edit one
# cheat -l          list topics
cheat() {
  local dir="$HOME/.config/cheats" topic style="dark"
  [[ "$DOTFILES_THEME" == "platinum" ]] && style="light"
  case "$1" in
    -l) ls "$dir" | sed 's/\.md$//'; return ;;
    -e) ${EDITOR:-nvim} "$dir/${2:-shell}.md"; return ;;
  esac
  topic="$1"
  if [[ -z "$topic" ]]; then
    topic=$(ls "$dir" | sed 's/\.md$//' | fzf --prompt='cheat > ' --preview "glow -s $style $dir/{}.md" --preview-window=right:70%:wrap) || return
  fi
  if [[ ! -f "$dir/$topic.md" ]]; then
    echo "no cheat sheet '$topic'. topics: $(ls "$dir" | sed 's/\.md$//' | tr '\n' ' ')"; return 1
  fi
  glow -s "$style" -p "$dir/$topic.md"
}
