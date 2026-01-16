#!/bin/bash

# Dotfiles installation script using GNU Stow

PACKAGES=(
    "alacritty-stow"
    "cava-stow"
    "fontconfig-stow"
    "gtk3-stow"
    "gtk4-stow"
    "hypr-stow"
    "kitty-stow"
    "lazygit-stow"
    "mako-stow"
    "nvim-stow"
    "rofi-stow"
    "tmux-stow"
    "waybar-stow"
    "zsh-stow"
)

THEME="gruvbox"
for arg in "$@"; do
    if [ "$arg" = "--monochrome" ]; then
        THEME="monochrome"
    elif [ "$arg" = "--gruvbox" ]; then
        THEME="gruvbox"
    elif [ "$arg" = "--nord" ]; then
        THEME="nord"
    elif [ "$arg" = "--dracula" ]; then
        THEME="dracula"
    elif [ "$arg" = "--tokyonight" ]; then
        THEME="tokyonight"
    elif [ "$arg" = "--onedark" ]; then
        THEME="onedark"
    elif [ "$arg" = "--onedarkpro" ]; then
        THEME="onedarkpro"
    elif [ "$arg" = "--catppuccin" ]; then
        THEME="catppuccin"
    elif [ "$arg" = "--catppuccin-mocha" ]; then
        THEME="catppuccin-mocha"
    elif [ "$arg" = "--catppuccin-frappe" ]; then
        THEME="catppuccin-frappe"
    fi
done

set_theme_symlinks() {
    local theme="$1"
    echo "Setting theme to $theme"

    mkdir -p ~/.config/alacritty/themes
    ln -sfn ~/.config/alacritty/themes/${theme}.toml ~/.config/alacritty/themes/current.toml

    mkdir -p ~/.config/kitty/kitty_themes
    ln -sfn ~/.config/kitty/kitty_themes/${theme}.conf ~/.config/kitty/kitty_themes/current.conf

    mkdir -p ~/.config/rofi/themes
    ln -sfn ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/themes/current.rasi

    mkdir -p ~/.config/waybar/themes
    ln -sfn ~/.config/waybar/themes/${theme}.css ~/.config/waybar/themes/current.css

    mkdir -p ~/.config/hypr/themes
    ln -sfn ~/.config/hypr/themes/${theme}.conf ~/.config/hypr/themes/current.conf

    mkdir -p ~/.config/mako/themes
    ln -sfn ~/.config/mako/themes/${theme}.conf ~/.config/mako/themes/current.conf

    mkdir -p ~/.config/zsh
    echo "export DOTFILES_THEME=$theme" > ~/.config/zsh/dotfiles-theme.env
}

case "$1" in
    "install")
        echo "Installing all dotfiles packages..."
        for package in "${PACKAGES[@]}"; do
            echo "Installing $package..."
            stow -t ~ "$package"
        done
        chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
        set_theme_symlinks "$THEME"
        echo "All packages installed successfully!"
        ;;
    "uninstall")
        echo "Uninstalling all dotfiles packages..."
        for package in "${PACKAGES[@]}"; do
            echo "Uninstalling $package..."
            stow -D -t ~ "$package"
        done
        echo "All packages uninstalled successfully!"
        ;;
    "restow")
        echo "Restowing all dotfiles packages..."
        for package in "${PACKAGES[@]}"; do
            echo "Restowing $package..."
            stow -R -t ~ "$package"
        done
        chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
        set_theme_symlinks "$THEME"
        echo "All packages restowed successfully!"
        ;;
    *)
        echo "Usage: $0 {install|uninstall|restow} [--monochrome]"
        echo ""
        echo "Commands:"
        echo "  install   - Install all dotfiles packages (default theme: gruvbox)"
        echo "  uninstall - Uninstall all dotfiles packages"
        echo "  restow    - Restow all dotfiles packages (uninstall then install)"
        echo ""
        echo "Options:"
        echo "  --monochrome  - Use monochrome theme instead of gruvbox"
        exit 1
        ;;
esac 