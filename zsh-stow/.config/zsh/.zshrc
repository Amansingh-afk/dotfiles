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
export PATH=$PATH:/home/dmann/.spicetify

eval "$(ssh-agent -s)" > /dev/null
ssh-add -q ~/.ssh/id_ed25519_vamaship

# --- Fzf gruvbox theme ---
export FZF_DEFAULT_OPTS='--color=fg:#ebdbb2,bg:#282828,hl:#d79921,fg+:'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS'#fbf1c7,bg+:#3c3836,hl+:#d79921,"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS'info:#b8bb26,prompt:#fe8019,"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS'spinner:#fb4934,header:#83a598'"

# --- Source all modular Zsh configs -----
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/theme.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/plugins.zsh
