#!/bin/bash

# Dotfiles installation script using GNU Stow
# Optimized for Hyprland on Fedora

PACKAGES=(
    "alacritty-stow"
    "cava-stow"
    "fontconfig-stow"
    "gtk3-stow"
    "gtk4-stow"
    "hypr-stow"
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
    case "$arg" in
        --monochrome) THEME="monochrome" ;;
        --gruvbox) THEME="gruvbox" ;;
        --catppuccin-mocha) THEME="catppuccin-mocha" ;;
    esac
done

set_theme_symlinks() {
    local theme="$1"
    echo "Setting theme to $theme"

    mkdir -p ~/.config/alacritty/themes
    ln -sfn ~/.config/alacritty/themes/${theme}.toml ~/.config/alacritty/themes/current.toml

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

configure_zshrc() {
    echo "Configuring ~/.zshrc to source custom configs..."
    
    # Check if our custom config block already exists
    if grep -q "# >>> dotfiles config >>>" ~/.zshrc 2>/dev/null; then
        echo "Custom config already present in ~/.zshrc"
        return
    fi
    
    # Append our custom config sourcing to .zshrc
    cat >> ~/.zshrc << 'EOF'

# >>> dotfiles config >>>
# Source custom configs from dotfiles
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh
[[ -f ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# Powerlevel10k (if installed)
[[ -f ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Zoxide (if installed)  
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
# <<< dotfiles config <<<
EOF
    echo "Added custom config to ~/.zshrc"
}

install_deps() {
    echo "==========================================="
    echo "Installing dependencies for Fedora..."
    echo "==========================================="
    
    # Core Hyprland packages
    echo ""
    echo "[1/6] Installing Hyprland and core packages..."
    sudo dnf install -y \
        hyprland waybar mako rofi wofi hyprpaper hyprlock \
        cliphist wl-clipboard polkit-gnome \
        qt6-qtbase qt6ct gtk4 gtk3 nautilus \
        alacritty neovim zsh tmux lazygit cava fontconfig \
        stow git
    
    # Fonts
    echo ""
    echo "[2/6] Installing fonts..."
    sudo dnf install -y \
        fontawesome-fonts powerline-fonts google-noto-fonts
    
    # Screenshot/media tools
    echo ""
    echo "[3/6] Installing screenshot and media tools..."
    sudo dnf install -y \
        grim slurp wf-recorder imagemagick \
        pamixer brightnessctl playerctl
    
    # Audio
    echo ""
    echo "[4/6] Installing audio packages..."
    sudo dnf install -y \
        pipewire pipewire-pulseaudio pipewire-alsa \
        wireplumber pavucontrol blueman
    
    # Dev tools
    echo ""
    echo "[5/6] Installing development tools..."
    sudo dnf install -y \
        gcc g++ make cmake nodejs npm python3 python3-pip \
        fzf zoxide ranger
    
    # Oh My Zsh and Powerlevel10k
    echo ""
    echo "[6/6] Installing Oh My Zsh and Powerlevel10k..."
    
    if [[ ! -d ~/.oh-my-zsh ]]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh already installed"
    fi
    
    if [[ ! -d ~/.local/share/powerlevel10k ]]; then
        echo "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/powerlevel10k
    else
        echo "Powerlevel10k already installed"
    fi
    
    # Zsh plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
    
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]]; then
        echo "Installing zsh-history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
    fi
    
    echo ""
    echo "==========================================="
    echo "Dependencies installed successfully!"
    echo "==========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./install.sh install"
    echo "  2. Set zsh as default shell: chsh -s \$(which zsh)"
    echo "  3. Log out and log back in"
}

case "$1" in
    "deps")
        install_deps
        ;;
    "install")
        echo "Installing all dotfiles packages..."
        
        # Remove conflicting files
        rm -f ~/.config/gtk-3.0/bookmarks 2>/dev/null
        
        for package in "${PACKAGES[@]}"; do
            echo "Installing $package..."
            stow -t ~ "$package"
        done
        
        chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
        set_theme_symlinks "$THEME"
        configure_zshrc
        
        echo ""
        echo "All packages installed successfully!"
        echo ""
        echo "To apply zsh changes, run: source ~/.zshrc"
        echo "To reload Hyprland, run: hyprctl reload"
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
        
        # Remove conflicting files
        rm -f ~/.config/gtk-3.0/bookmarks 2>/dev/null
        
        for package in "${PACKAGES[@]}"; do
            echo "Restowing $package..."
            stow -R -t ~ "$package"
        done
        
        chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
        set_theme_symlinks "$THEME"
        configure_zshrc
        
        echo "All packages restowed successfully!"
        ;;
    *)
        echo "Dotfiles Installation Script"
        echo ""
        echo "Usage: $0 {deps|install|uninstall|restow} [--theme]"
        echo ""
        echo "Commands:"
        echo "  deps      - Install all system dependencies (run first on new machine)"
        echo "  install   - Install all dotfiles packages"
        echo "  uninstall - Uninstall all dotfiles packages"
        echo "  restow    - Restow all packages (uninstall then install)"
        echo ""
        echo "Theme options:"
        echo "  --gruvbox          (default)"
        echo "  --monochrome"
        echo "  --catppuccin-mocha"
        echo ""
        echo "Example (new machine setup):"
        echo "  $0 deps              # Install dependencies"
        echo "  $0 install           # Install dotfiles"
        echo "  chsh -s \$(which zsh)  # Set zsh as default shell"
        exit 1
        ;;
esac
