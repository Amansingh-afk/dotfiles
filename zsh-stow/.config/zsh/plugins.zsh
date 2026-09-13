# Oh My Zsh + plugins (installed by ./install.sh deps)
export ZSH="$HOME/.oh-my-zsh"
if [[ -d "$ZSH" ]]; then
  zstyle ':omz:update' mode auto
  zstyle ':omz:update' frequency 1
  plugins=(
    aliases
    fzf
    zoxide
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
  )
  source "$ZSH/oh-my-zsh.sh"
else
  # Fallback without oh-my-zsh: completion + zoxide only
  autoload -Uz compinit && compinit
  zmodload zsh/complist
  command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
fi
zstyle ':completion:*' menu select
_comp_options+=(globdots)

# Highlight colours (zsh-syntax-highlighting must already be loaded)
[[ -f ~/.zsh/zsh-highlight-config.zsh ]] && source ~/.zsh/zsh-highlight-config.zsh
