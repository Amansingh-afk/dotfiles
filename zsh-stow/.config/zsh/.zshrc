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

# --- Toolchains (lazy where they are slow) ---
# nvm: put the default node on PATH directly, load nvm itself only on first `nvm` call.
export NVM_DIR="$HOME/.nvm"
if [[ -r "$NVM_DIR/alias/default" ]]; then
  _nvm_default=("$NVM_DIR"/versions/node/v${$(<"$NVM_DIR/alias/default")#v}*/bin(N[-1]))
  [[ -n "$_nvm_default" ]] && export PATH="$_nvm_default:$PATH"
  unset _nvm_default
fi
nvm() { unset -f nvm; source "$NVM_DIR/nvm.sh"; nvm "$@"; }

# conda: base env on PATH, hook loaded on first `conda` call.
if [[ -d "$HOME/miniconda3" ]]; then
  export PATH="$HOME/miniconda3/bin:$PATH"
  conda() { unset -f conda; eval "$("$HOME/miniconda3/bin/conda" shell.zsh hook)"; conda "$@"; }
fi

# bun
if [[ -d "$HOME/.bun" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
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

# --- Fzf theme (switchable) ---
case "$DOTFILES_THEME" in
  monochrome)       export FZF_DEFAULT_OPTS='--color=fg:#e6e6e6,bg:-1,hl:#b3b3b3,fg+:#f0f0f0,bg+:#2e2e2e,hl+:#c2c2c2,info:#adadad,prompt:#b0b0b0,spinner:#9a9a9a,header:#a6a6a6' ;;
  bsod)             export FZF_DEFAULT_OPTS='--color=fg:#FFFFFF,bg:#0000AA,hl:#55FFFF,fg+:#FFFFFF,bg+:#AAAAAA,hl+:#55FFFF,info:#55FF55,prompt:#55FFFF,spinner:#AAAAAA,header:#AAAAAA' ;;
  platinum)         export FZF_DEFAULT_OPTS='--color=fg:#000000,bg:#DCDCDC,hl:#9999FF,fg+:#000000,bg+:#c0c0c0,hl+:#AAAAFF,info:#808080,prompt:#9999FF,spinner:#9b9b9b,header:#6e6e6e' ;;
  catppuccin-mocha) export FZF_DEFAULT_OPTS='--color=fg:#cdd6f4,bg:-1,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#89b4fa,prompt:#cba6f7,spinner:#f5e0dc,header:#94e2d5' ;;
  *)                export FZF_DEFAULT_OPTS='--color=fg:#ebdbb2,bg:#282828,hl:#d79921,fg+:#fbf1c7,bg+:#3c3836,hl+:#d79921,info:#b8bb26,prompt:#fe8019,spinner:#fb4934,header:#83a598' ;;
esac

# --- Modular configs ---
# plugins.zsh runs oh-my-zsh (which runs compinit); the others rely on that.
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/keybindings.zsh"
source "$ZDOTDIR/theme.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/aliases.zsh"

# --- Machine-local overrides and secrets (not in the repo) ---
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
