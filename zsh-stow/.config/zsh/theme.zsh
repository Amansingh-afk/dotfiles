# Enable colors and prompt
autoload -U colors && colors

# Disable conda's own prompt modifier — starship handles it
export CONDA_CHANGEPS1=false

if [[ "$DOTFILES_THEME" = "retro" ]]; then
  # BSOD / DOS aesthetic — raw DOS-style prompt
  PROMPT='%F{cyan}C:\%~>%f '
  RPROMPT='%F{white}%T%f'
elif command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback: simple prompt
  PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
fi
