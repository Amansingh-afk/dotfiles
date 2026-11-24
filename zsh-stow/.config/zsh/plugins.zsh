# Plugins (standalone, no oh-my-zsh)

# fzf keybindings (Ctrl-R history, Ctrl-T files, Alt-C cd)
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

# eza listings
if command -v eza >/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -la --icons --git'
  alias lt='eza --tree --level=2 --icons'
fi

# zoxide init
eval "$(zoxide init zsh)"

# autosuggestions
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# history substring search
HSS=~/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
if [ -f "$HSS" ]; then
  source "$HSS"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

# syntax highlighting (must stay last)
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.zsh/zsh-highlight-config.zsh ] && source ~/.zsh/zsh-highlight-config.zsh
