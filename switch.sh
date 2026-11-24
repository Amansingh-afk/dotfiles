#!/usr/bin/env bash
# Point ~/.config at either the acer setup (this worktree) or the ship setup.
#   ./switch.sh acer | ship | status
# Only re-points existing symlinks into these two checkouts. Never replaces a
# real file or directory (sole exception: btop.conf, which is backed up).
set -euo pipefail

ACER="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
SHIP="${SHIP_DIR:-$(dirname "$ACER")/dotfiles}"
CFG="$HOME/.config"
# tmux, lazygit, fontconfig are identical on both sides; kitty/noctalia are ship-only.
ENTRIES=(
    alacritty:alacritty cava:cava fastfetch:fastfetch gtk3:gtk-3.0 gtk4:gtk-4.0
    hypr:hypr mako:mako nvim:nvim rofi:rofi starship:starship.toml
    waybar:waybar zsh:zsh
)

status() { for e in "${ENTRIES[@]}"; do printf '%-15s %s\n' "${e#*:}" "$(readlink -f "$CFG/${e#*:}")"; done; }

link_all() {
    local root="$1" e src dst cur
    # Validate everything first so a failure leaves nothing half-switched.
    for e in "${ENTRIES[@]}"; do
        src="$root/${e%%:*}-stow/.config/${e#*:}"; dst="$CFG/${e#*:}"
        [[ -e "$src" ]] || { echo "missing source: $src" >&2; exit 1; }
        [[ -L "$dst" || ! -e "$dst" ]] || { echo "refusing: $dst is not a symlink" >&2; exit 1; }
        cur="$(readlink -f "$dst" || true)"
        [[ -z "$cur" || ! -e "$dst" || "$cur" == "$ACER"/* || "$cur" == "$SHIP"/* ]] \
            || { echo "refusing: $dst points to $cur" >&2; exit 1; }
    done
    for e in "${ENTRIES[@]}"; do
        ln -sfnr "$root/${e%%:*}-stow/.config/${e#*:}" "$CFG/${e#*:}"
    done
}

# Only touch the desktop when run inside a Hyprland session.
live() { [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" && -z "${NO_RELOAD:-}" ]]; }
spawn() { hyprctl dispatch exec "$1" >/dev/null; }

case "${1:-}" in
acer)
    link_all "$ACER"
    mkdir -p "$CFG/btop"
    if [[ -f "$CFG/btop/btop.conf" && ! -L "$CFG/btop/btop.conf" ]]; then
        mv "$CFG/btop/btop.conf" "$CFG/btop/btop.conf.ship"
    fi
    ln -sfn "$ACER/btop-stow/.config/btop/btop.conf" "$CFG/btop/btop.conf"
    if live; then
        pkill -f 'qs -c noctalia-shell' || true
        sleep 1; hyprctl reload >/dev/null
        pgrep -x mako >/dev/null || spawn mako
        pgrep -x hyprpaper >/dev/null || spawn hyprpaper
        pgrep -x waybar >/dev/null || spawn waybar
    fi ;;
ship)
    link_all "$SHIP"
    if [[ -L "$CFG/btop/btop.conf" ]]; then
        rm "$CFG/btop/btop.conf"
        [[ ! -f "$CFG/btop/btop.conf.ship" ]] || mv "$CFG/btop/btop.conf.ship" "$CFG/btop/btop.conf"
    fi
    if live; then
        for p in waybar mako hyprpaper; do pkill -x "$p" || true; done
        sleep 1; hyprctl reload >/dev/null
        pgrep -f 'qs -c noctalia-shell' >/dev/null || spawn 'qs -c noctalia-shell'
    fi ;;
status) status; exit ;;
*) echo "usage: $0 {acer|ship|status}" >&2; exit 1 ;;
esac
status
