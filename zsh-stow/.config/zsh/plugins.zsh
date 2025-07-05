# Plugins
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

# zoxide init
eval "$(zoxide init zsh)"

#Source configs
source ~/.zsh/zsh-highlight-config.zsh
