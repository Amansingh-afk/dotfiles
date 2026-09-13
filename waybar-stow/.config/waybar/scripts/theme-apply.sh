#!/usr/bin/env bash
# theme-apply.sh <theme> — link or generate every per-app theme file for one colour theme.
# The single place that knows which apps are themed. Called by install.sh (restow --<theme>)
# and by appearance-switcher.sh (Super+Alt+T). Restarting apps is the caller's job.
set -uo pipefail
theme="${1:?theme name}"
C="$HOME/.config"

# symlinked "current" files
ln -sfn "$C/kitty/themes/$theme.conf"   "$C/kitty/themes/current.conf"
ln -sfn "$C/rofi/themes/$theme.rasi"    "$C/rofi/themes/current.rasi"
ln -sfn "$C/waybar/themes/$theme.css"   "$C/waybar/themes/current.css"
ln -sfn "$C/hypr/themes/$theme.conf"    "$C/hypr/themes/current.conf"
ln -sfn "$C/mako/themes/$theme.conf"    "$C/mako/themes/current.conf"
ln -sfn "$C/yazi/themes/$theme.toml"    "$C/yazi/theme.toml"

# waybar: layout + generated config/style.css/rofi overrides
"$C/waybar/scripts/waybar-layout.sh" apply-for-theme "$theme" --no-restart >/dev/null 2>&1

# gtk: theme css, dark/light preference
[[ -f "$C/gtk-4.0/themes/$theme.css" ]] && cp "$C/gtk-4.0/themes/$theme.css" "$C/gtk-4.0/gtk.css"
[[ -f "$C/gtk-3.0/themes/$theme.css" ]] && cp "$C/gtk-3.0/themes/$theme.css" "$C/gtk-3.0/gtk.css"
prefer_dark=1; scheme="prefer-dark"
[[ "$theme" == "platinum" ]] && { prefer_dark=0; scheme="prefer-light"; }
for v in gtk-3.0 gtk-4.0; do
  [[ -f "$C/$v/settings.ini.in" ]] && sed "s/@PREFER_DARK@/$prefer_dark/" "$C/$v/settings.ini.in" > "$C/$v/settings.ini"
done
command -v gsettings &>/dev/null && gsettings set org.gnome.desktop.interface color-scheme "$scheme" 2>/dev/null

# btop: generated config (btop rewrites it on exit, so it is never tracked)
case "$theme" in
  gruvbox) btop_theme="gruvbox_dark" ;;
  monochrome) btop_theme="greyscale" ;;
  catppuccin-mocha) btop_theme="catppuccin_mocha" ;;
  bsod) btop_theme="bsod" ;;
  platinum) btop_theme="paper" ;;
  *) btop_theme="Default" ;;
esac
[[ -f "$C/btop/btop.conf.in" ]] && sed "s/@THEME@/$btop_theme/" "$C/btop/btop.conf.in" > "$C/btop/btop.conf"

# starship: generated copy with the palette line swapped
[[ -f "$C/starship/starship.toml" ]] && sed "s/^palette = .*/palette = \"$theme\"/" "$C/starship/starship.toml" > "$C/starship/current.toml"

# zsh: env for new shells (bat, delta, glow, lazygit, fzf read it in theme.zsh)
mkdir -p "$C/zsh"
echo "export DOTFILES_THEME=$theme" > "$C/zsh/dotfiles-theme.env"

# running kitties reload colours
pkill -USR1 -x kitty 2>/dev/null
exit 0
