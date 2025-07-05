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

case "$1" in
    "install")
        echo "Installing all dotfiles packages..."
        for package in "${PACKAGES[@]}"; do
            echo "Installing $package..."
            stow -t ~ "$package"
        done
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
        echo "All packages restowed successfully!"
        ;;
    *)
        echo "Usage: $0 {install|uninstall|restow}"
        echo ""
        echo "Commands:"
        echo "  install   - Install all dotfiles packages"
        echo "  uninstall - Uninstall all dotfiles packages"
        echo "  restow    - Restow all dotfiles packages (uninstall then install)"
        exit 1
        ;;
esac 