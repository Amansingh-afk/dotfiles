#!/usr/bin/env bash
# theme.sh [gruvbox|monochrome] [--no-reload]   no name = toggle. Bar layout stays outline.
set -euo pipefail
C="$HOME/.config"; W="$C/waybar"
current() { basename "$(readlink "$W/themes/current.css" 2>/dev/null || echo gruvbox.css)" .css; }

theme="${1:-}"; [[ "$theme" == --* ]] && theme=""
if [[ -z "$theme" ]]; then [[ "$(current)" == gruvbox ]] && theme=monochrome || theme=gruvbox; fi
case "$theme" in
  gruvbox)    btop=gruvbox_dark; mono="" ;;
  monochrome) btop=greyscale;    mono=1 ;;
  *) echo "usage: $0 [gruvbox|monochrome] [--no-reload]" >&2; exit 1 ;;
esac

# symlinks (relative, gitignored)
for t in kitty:conf rofi:rasi waybar:css hypr:conf mako:conf lazygit:yml; do
  ln -sfn "$theme.${t#*:}" "$C/${t%%:*}/themes/current.${t#*:}"
done
ln -sfn "themes/$theme.toml" "$C/yazi/theme.toml"

# generated copies (gitignored)
if [[ -n "$mono" ]]; then
  sed -E "s/color='#[0-9a-fA-F]{6}'/color='#e6e6e6'/g; s/ss-cpu-temp.sh flat/& mono/" "$W/config.in" > "$W/config"
else
  cp "$W/config.in" "$W/config"
fi
cp "$C/gtk-3.0/themes/$theme.css" "$C/gtk-3.0/gtk.css"
cp "$C/gtk-4.0/themes/$theme.css" "$C/gtk-4.0/gtk.css"
sed "s/@THEME@/$btop/" "$C/btop/btop.conf.in" > "$C/btop/btop.conf"
sed "s/^palette = .*/palette = \"$theme\"/" "$C/starship/starship.toml" > "$C/starship/current.toml"
echo "export DOTFILES_THEME=$theme" > "$C/zsh/dotfiles-theme.env"

[[ " $* " == *" --no-reload "* ]] && exit 0
pkill -USR1 -x kitty || true
hyprctl reload >/dev/null 2>&1 || true
makoctl reload 2>/dev/null || true
pkill -x waybar || true; sleep 0.3; setsid -f waybar >/dev/null 2>&1
notify-send "Theme" "$theme" -t 2000 2>/dev/null || true
