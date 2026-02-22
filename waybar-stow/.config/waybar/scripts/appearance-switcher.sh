#!/usr/bin/env bash

set -euo pipefail

# Theme & Wallpaper Switcher - Sleek Edition

THEMES_DIR="$HOME/.config/waybar/themes"
WALL_DIR_DEFAULT="$HOME/realm/builds/dotfiles/wallpapers"
WALL_DIR_ALT="$HOME/Pictures/Wallpapers"
CURRENT_WALL_LINK="$WALL_DIR_DEFAULT/current"
CONFIG="$HOME/.config/rofi/theme-menu.rasi"

# Determine wallpapers directory
if [ -d "$WALL_DIR_DEFAULT" ]; then
    WALL_DIR="$WALL_DIR_DEFAULT"
elif [ -d "$WALL_DIR_ALT" ]; then
    WALL_DIR="$WALL_DIR_ALT"
else
    WALL_DIR=""
fi

# Get available themes
get_themes() {
    ls -1 "$THEMES_DIR"/*.css 2>/dev/null | xargs -n1 basename | sed 's/\.css$//' | grep -v "^current$"
}

# Get current theme
get_current_theme() {
    if [ -L "$THEMES_DIR/current.css" ]; then
        readlink "$THEMES_DIR/current.css" | xargs basename | sed 's/\.css$//'
    else
        echo "unknown"
    fi
}

# Apply theme
set_theme() {
    local theme="$1"
    ln -sfn ~/.config/alacritty/themes/${theme}.toml ~/.config/alacritty/themes/current.toml 2>/dev/null || true
    ln -sfn ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/themes/current.rasi 2>/dev/null || true
    ln -sfn ~/.config/waybar/themes/${theme}.css ~/.config/waybar/themes/current.css 2>/dev/null || true
    ln -sfn ~/.config/hypr/themes/${theme}.conf ~/.config/hypr/themes/current.conf 2>/dev/null || true
    ln -sfn ~/.config/mako/themes/${theme}.conf ~/.config/mako/themes/current.conf 2>/dev/null || true
    echo "export DOTFILES_THEME=$theme" > ~/.config/zsh/dotfiles-theme.env
    
    # Regenerate waybar style.css
    if [[ -f ~/.config/waybar/themes/${theme}.css ]] && [[ -f ~/.config/waybar/configs/blur/style.css ]]; then
        cat ~/.config/waybar/themes/${theme}.css ~/.config/waybar/configs/blur/style.css > ~/.config/waybar/style.css
    fi
    
    pkill -SIGUSR2 waybar 2>/dev/null || killall waybar 2>/dev/null && waybar &
    makoctl reload 2>/dev/null || true
    notify-send "󰏘 Theme" "$theme" -t 2000
}

# Show themes menu
show_themes() {
    local current=$(get_current_theme)
    local entries=""
    for theme in $(get_themes); do
        if [ "$theme" = "$current" ]; then
            entries+="󰸞  $theme\n"
        else
            entries+="󰏘  $theme\n"
        fi
    done
    entries=$(echo -e "$entries" | sed '/^$/d')

    selected=$(echo -e "$entries" | rofi -dmenu -i -config "$CONFIG")
    [ -z "$selected" ] && return

    theme_name=$(echo "$selected" | sed 's/^[^ ]* *//')
    [ "$theme_name" != "$current" ] && set_theme "$theme_name"
}

# Show wallpapers menu
show_wallpapers() {
    if [ -z "$WALL_DIR" ]; then
        notify-send "󰸉 Wallpaper" "No wallpapers directory found"
        return
    fi

    mapfile -t FILES < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

    if [ ${#FILES[@]} -eq 0 ]; then
        notify-send "󰸉 Wallpaper" "No images found"
        return
    fi

    # Build list
    entries=""
    for f in "${FILES[@]}"; do
        entries+="󰸉  $(basename "$f")\n"
    done
    entries=$(echo -e "$entries" | sed '/^$/d')

    selected=$(echo -e "$entries" | rofi -dmenu -i -config "$CONFIG")
    [ -z "$selected" ] && return

    wall_name=$(echo "$selected" | sed 's/^[^ ]* *//')
    SEL_FILE="$WALL_DIR/$wall_name"

    if ! hyprctl hyprpaper ls >/dev/null 2>&1; then
        notify-send "󰸉 Wallpaper" "hyprpaper not running"
        return
    fi

    hyprctl hyprpaper preload "$SEL_FILE" >/dev/null 2>&1 || true
    mapfile -t MONS < <(hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p')

    for m in "${MONS[@]}"; do
        hyprctl hyprpaper wallpaper "$m,$SEL_FILE" >/dev/null 2>&1 || true
    done

    ln -sfn "$SEL_FILE" "$CURRENT_WALL_LINK"
    notify-send "󰸉 Wallpaper" "$wall_name" -t 2000
}

# Main menu
main_menu() {
    local options="󰏘  Themes\n󰸉  Wallpapers"
    selected=$(echo -e "$options" | rofi -dmenu -i -config "$CONFIG")

    case "$selected" in
        *Themes*) show_themes ;;
        *Wallpapers*) show_wallpapers ;;
    esac
}

main_menu
