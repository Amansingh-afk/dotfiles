# Sourced by every zsh. Points zsh at the dotfiles config dir.
export ZDOTDIR="$HOME/.config/zsh"

# ssh-agent via systemd user socket (enabled by install.sh)
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket}"
