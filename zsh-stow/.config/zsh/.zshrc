# Zsh main configuration file
# This file sets up core environment, history, and sources all modular configs from ~/.config/zsh/*.zsh

# --- Update Settings ---
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# --- History ---
HIST_STAMPS="dd.mm.yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# --- Completion ---
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# --- Directory options ---
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# --- Environment ---
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:$HOME/.spicetify
if [ -f "$HOME/.config/zsh/dotfiles-theme.env" ]; then
  source "$HOME/.config/zsh/dotfiles-theme.env"
fi

# Start ssh-agent if needed
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
[[ -f ~/.ssh/id_ed25519_vamaship ]] && ssh-add -q ~/.ssh/id_ed25519_vamaship 2>/dev/null

# --- Fzf theme (switchable) ---
if [ "$DOTFILES_THEME" = "monochrome" ]; then
  export FZF_DEFAULT_OPTS='--color=fg:#e6e6e6,bg:#121212,hl:#b3b3b3,fg+:#f0f0f0,bg+:#2e2e2e,hl+:#c2c2c2,info:#adadad,prompt:#b0b0b0,spinner:#9a9a9a,header:#a6a6a6'
else
  export FZF_DEFAULT_OPTS='--color=fg:#ebdbb2,bg:#282828,hl:#d79921,fg+:#fbf1c7,bg+:#3c3836,hl+:#d79921,info:#b8bb26,prompt:#fe8019,spinner:#fb4934,header:#83a598'
fi

# --- Source all modular Zsh configs -----
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/theme.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/plugins.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias ld='lazydocker'

fpath+=~/.zfunc; autoload -Uz compinit; compinit
