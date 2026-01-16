#!/usr/bin/env bash

set -euo pipefail

# Combined appearance switcher for themes and wallpapers

THEMES_DIR="$HOME/.config/waybar/themes"
WALL_DIR_DEFAULT="$HOME/realm/builds/dotfiles/wallpapers"
WALL_DIR_ALT="$HOME/Pictures/Wallpapers"
CURRENT_WALL_LINK="$WALL_DIR_DEFAULT/current"

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
    ln -sfn ~/.config/alacritty/themes/${theme}.toml ~/.config/alacritty/themes/current.toml
    ln -sfn ~/.config/kitty/kitty_themes/${theme}.conf ~/.config/kitty/kitty_themes/current.conf
    ln -sfn ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/themes/current.rasi
    ln -sfn ~/.config/waybar/themes/${theme}.css ~/.config/waybar/themes/current.css
    ln -sfn ~/.config/hypr/themes/${theme}.conf ~/.config/hypr/themes/current.conf
    ln -sfn ~/.config/mako/themes/${theme}.conf ~/.config/mako/themes/current.conf
    echo "export DOTFILES_THEME=$theme" > ~/.config/zsh/dotfiles-theme.env
    pkill -SIGUSR2 waybar 2>/dev/null || killall -SIGUSR2 waybar 2>/dev/null || true
    pkill -SIGUSR1 kitty 2>/dev/null || true
    makoctl reload 2>/dev/null || true
    notify-send "Appearance" "Theme: $theme" -t 2000
}

# Show themes menu
show_themes() {
    local current=$(get_current_theme)
    local entries=""
    for theme in $(get_themes); do
        if [ "$theme" = "$current" ]; then
            entries+="󰸞 $theme (current)\n"
        else
            entries+="󰏘 $theme\n"
        fi
    done
    entries=$(echo -e "$entries" | sed '/^$/d')

    selected=$(echo -e "$entries" | rofi -dmenu -i -p "Theme" -theme-str 'window {width: 300px;}')
    [ -z "$selected" ] && return

    theme_name=$(echo "$selected" | sed 's/^[^ ]* //' | sed 's/ (current)$//')
    [ "$theme_name" != "$current" ] && set_theme "$theme_name"
}

# Show wallpapers menu
show_wallpapers() {
    if [ -z "$WALL_DIR" ]; then
        notify-send "Appearance" "No wallpapers directory found"
        return
    fi

    mapfile -t FILES < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

    if [ ${#FILES[@]} -eq 0 ]; then
        notify-send "Appearance" "No images found in $WALL_DIR"
        return
    fi

    build_rofi_list() {
        for f in "${FILES[@]}"; do
            printf '%s\0icon\x1f%s\n' "$(basename "$f")" "$f"
        done
    }

    SELECTION_INDEX=$(build_rofi_list | rofi -dmenu -i -p "Wallpaper" -show-icons -format i -theme "$HOME/.config/rofi/themes/current.rasi")

    if [ -z "${SELECTION_INDEX}" ] || [ "$SELECTION_INDEX" = "-1" ]; then
        return
    fi

    SEL_FILE="${FILES[$SELECTION_INDEX]}"

    if ! hyprctl hyprpaper ls >/dev/null 2>&1; then
        notify-send "Appearance" "hyprpaper IPC not available"
        return
    fi

    hyprctl hyprpaper preload "$SEL_FILE" >/dev/null 2>&1 || true
    mapfile -t MONS < <(hyprctl monitors | sed -n 's/^Monitor \([^ ]*\).*/\1/p')

    for m in "${MONS[@]}"; do
        hyprctl hyprpaper wallpaper "$m,$SEL_FILE" >/dev/null 2>&1 || true
    done

    mkdir -p "$WALL_DIR_DEFAULT"
    ln -sfn "$SEL_FILE" "$CURRENT_WALL_LINK"
    notify-send "Appearance" "Wallpaper: $(basename "$SEL_FILE")" -t 2000
}

# Main menu
main_menu() {
    local options="󰏘 Themes\n󰸉 Wallpapers"
    selected=$(echo -e "$options" | rofi -dmenu -i -p "Appearance" -theme-str 'window {width: 250px;}')

    case "$selected" in
        *Themes*) show_themes ;;
        *Wallpapers*) show_wallpapers ;;
    esac
}

main_menu
