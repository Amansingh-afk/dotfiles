# Oh My Zsh Plugins (if installed)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  plugins=(
    aliases
    colorize
    eza
    fzf
    zoxide
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
  )
  source $ZSH/oh-my-zsh.sh
fi

# zoxide init (if installed)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Source highlight config if exists
[[ -f ~/.zsh/zsh-highlight-config.zsh ]] && source ~/.zsh/zsh-highlight-config.zsh
