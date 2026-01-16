# Enable colors and prompt
autoload -U colors && colors

# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k Theme (if installed)
if [[ -f ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
  # Fallback: simple prompt
  PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
fi
