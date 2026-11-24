# Gruvbox for TUI tools + prompt
autoload -U colors && colors
export CONDA_CHANGEPS1=false

export FZF_DEFAULT_OPTS='--color=fg:#ebdbb2,bg:#282828,hl:#d79921,fg+:#fbf1c7,bg+:#3c3836,hl+:#d79921,info:#b8bb26,prompt:#fe8019,spinner:#fb4934,header:#83a598'
export BAT_THEME='gruvbox-dark'
export GLAMOUR_STYLE='dark'
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
fi
