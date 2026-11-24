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
  # No oh-my-zsh: plugins from Fedora packages / ~/.local/share
  autoload -Uz compinit && compinit
  zmodload zsh/complist
  bindkey -v   # before plugin keys; keybindings.zsh sets it again
  [[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
  command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
  [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  HSS=~/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  if [[ -f "$HSS" ]]; then
    source "$HSS"
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
  fi
  [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
zstyle ':completion:*' menu select
_comp_options+=(globdots)

# Highlight colours (zsh-syntax-highlighting must already be loaded)
[[ -f ~/.zsh/zsh-highlight-config.zsh ]] && source ~/.zsh/zsh-highlight-config.zsh
