# Enable colors and prompt
autoload -U colors && colors

# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k Theme
source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
