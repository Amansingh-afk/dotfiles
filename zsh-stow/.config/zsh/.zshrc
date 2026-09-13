# Zsh main configuration file
# Loaded via ZDOTDIR=~/.config/zsh (set in ~/.zshenv). Sources the modular *.zsh files here.

# --- History ---
HIST_STAMPS="dd.mm.yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

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
[[ -f "$ZDOTDIR/dotfiles-theme.env" ]] && source "$ZDOTDIR/dotfiles-theme.env"

# --- Toolchains ---
export PATH="$HOME/go/bin:$PATH"
export TERMINAL=kitty
export MANPAGER='nvim +Man!'

# mise: node / bun / python versions (global: ~/.config/mise/config.toml, per project: .mise.toml or .nvmrc)
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# conda: only for conda envs (e.g. iitb-aids). Base is NOT on PATH; hook loads on first `conda` call.
if [[ -d "$HOME/miniconda3" ]]; then
  conda() { unset -f conda; eval "$("$HOME/miniconda3/bin/conda" shell.zsh hook)"; conda "$@"; }
fi

# nix
[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

# google cloud sdk
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# --- ssh key (agent is the systemd user socket, see ~/.zshenv) ---
# Load the default key once per login; prompts for the passphrase only until it is added.
if [[ -f ~/.ssh/id_ed25519 ]] && ! ssh-add -l >/dev/null 2>&1; then
  ssh-add -q ~/.ssh/id_ed25519 2>/dev/null
fi

# --- Modular configs ---
# plugins.zsh runs oh-my-zsh (which runs compinit); theme.zsh sets per-theme env (fzf, bat, delta, glow, lazygit, starship).
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/keybindings.zsh"
source "$ZDOTDIR/theme.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

# --- Shell history + per-directory env (after plugins so their keybinds win) ---
command -v atuin &>/dev/null && eval "$(atuin init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# --- Machine-local overrides and secrets (not in the repo) ---
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
