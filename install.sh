#!/bin/bash

# Dotfiles installation script using GNU Stow
# Optimized for Hyprland on Fedora

set -eo pipefail
cd "$(dirname "$(readlink -f "$0")")"

PACKAGES=(
    "alacritty-stow"
    "btop-stow"
    "cava-stow"
    "fastfetch-stow"
    "fontconfig-stow"
    "gtk3-stow"
    "gtk4-stow"
    "hypr-stow"
    "mako-stow"
    "nvim-stow"
    "rofi-stow"
    "starship-stow"
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
        --bsod) THEME="bsod" ;;
        --platinum) THEME="platinum" ;;
    esac
done

set_theme_symlinks() {
    local theme="$1"
    echo "Setting theme to $theme"

    ln -sfn ~/.config/alacritty/themes/${theme}.toml ~/.config/alacritty/themes/current.toml
    ln -sfn ~/.config/rofi/themes/${theme}.rasi ~/.config/rofi/themes/current.rasi
    ln -sfn ~/.config/waybar/themes/${theme}.css ~/.config/waybar/themes/current.css
    ln -sfn ~/.config/hypr/themes/${theme}.conf ~/.config/hypr/themes/current.conf
    ln -sfn ~/.config/mako/themes/${theme}.conf ~/.config/mako/themes/current.conf

    # Waybar layout + generated config/style.css/rofi overrides (see waybar-layout.sh)
    ~/.config/waybar/scripts/waybar-layout.sh apply-for-theme "$theme" --no-restart

    # GTK: theme css for Nautilus etc. + dark/light preference for libadwaita apps
    if [[ -f ~/.config/gtk-4.0/themes/${theme}.css ]]; then
        cp ~/.config/gtk-4.0/themes/${theme}.css ~/.config/gtk-4.0/gtk.css
        echo "Applied GTK4 theme: $theme"
    fi
    if [[ -f ~/.config/gtk-3.0/themes/${theme}.css ]]; then
        cp ~/.config/gtk-3.0/themes/${theme}.css ~/.config/gtk-3.0/gtk.css
        echo "Applied GTK3 theme: $theme"
    fi
    local prefer_dark=1 scheme="prefer-dark" v
    if [[ "$theme" == "platinum" ]]; then prefer_dark=0; scheme="prefer-light"; fi
    for v in gtk-3.0 gtk-4.0; do
        sed "s/@PREFER_DARK@/$prefer_dark/" ~/.config/$v/settings.ini.in > ~/.config/$v/settings.ini
    done
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface color-scheme "$scheme" 2>/dev/null || true
    fi

    echo "export DOTFILES_THEME=$theme" > ~/.config/zsh/dotfiles-theme.env
}

write_gtk_bookmarks() {
    # Nautilus sidebar bookmarks need absolute URIs, so generate per user.
    local dir
    {
        for dir in Pictures Documents Music Videos Downloads; do
            [[ -d "$HOME/$dir" ]] && echo "file://$HOME/$dir"
        done
    } > ~/.config/gtk-3.0/bookmarks
}

setup_zsh() {
    # zsh reads ~/.zshenv (stowed) which sets ZDOTDIR=~/.config/zsh, so the
    # repo's .zshrc is used and a leftover ~/.zshrc would be ignored. Move it aside.
    if [[ -f ~/.zshrc && ! -L ~/.zshrc ]]; then
        mv ~/.zshrc ~/.zshrc.pre-dotfiles
        echo "Moved old ~/.zshrc to ~/.zshrc.pre-dotfiles (put machine-specific bits in ~/.zshrc.local)"
    fi
    if [[ ! -f ~/.zshrc.local ]]; then
        cat > ~/.zshrc.local <<'LOCAL'
# Machine-specific zsh config and secrets. Not tracked in the dotfiles repo.
LOCAL
        chmod 600 ~/.zshrc.local
    fi

    # ssh-agent as a systemd user socket (SSH_AUTH_SOCK is set in ~/.zshenv)
    if systemctl --user list-unit-files ssh-agent.socket &>/dev/null; then
        systemctl --user enable --now ssh-agent.socket 2>/dev/null || true
    fi
}

install_nerd_font() {
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    if fc-list | grep -qi "nerd font"; then
        echo "Nerd Fonts already installed"
        return
    fi
    echo "Downloading JetBrains Mono Nerd Font..."
    local tmp
    tmp=$(mktemp -d)
    if curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$tmp/nf.zip"; then
        unzip -q "$tmp/nf.zip" -d "$font_dir/JetBrainsMonoNerd"
        fc-cache -f "$font_dir"
        echo "Nerd Fonts installed to $font_dir/JetBrainsMonoNerd"
    else
        echo "Warning: Could not download Nerd Fonts. Install manually from https://www.nerdfonts.com/font-downloads"
    fi
    rm -rf "$tmp"
}

install_vt323_font() {
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    if fc-list | grep -qi "VT323"; then
        echo "VT323 font already installed"
        return
    fi
    echo "Installing VT323 font for bsod theme..."
    if curl -fsSL "https://github.com/google/fonts/raw/main/ofl/vt323/VT323-Regular.ttf" -o "$font_dir/VT323-Regular.ttf"; then
        fc-cache -f "$font_dir"
        echo "VT323 font installed"
    else
        echo "Warning: Could not download VT323. Install manually from Google Fonts."
    fi
}

install_deps() {
    echo "==========================================="
    echo "Installing dependencies for Fedora..."
    echo "==========================================="

    echo ""
    echo "[1/6] Installing Hyprland and core packages..."
    sudo dnf install -y \
        hyprland waybar mako rofi hyprpaper hyprlock hypridle lxpolkit \
        xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
        cliphist wl-clipboard \
        qt6-qtbase qt6ct gtk4 gtk3 nautilus \
        alacritty neovim zsh tmux lazygit btop cava fastfetch fontconfig \
        stow git curl unzip

    echo ""
    echo "[2/6] Installing fonts..."
    sudo dnf install -y google-noto-sans-fonts google-noto-serif-fonts google-noto-color-emoji-fonts jetbrains-mono-fonts-all rsms-inter-fonts
    install_nerd_font
    install_vt323_font

    echo ""
    echo "[3/6] Installing screenshot and media tools..."
    sudo dnf install -y \
        grim slurp wf-recorder ImageMagick \
        brightnessctl playerctl upower

    echo ""
    echo "[4/6] Installing audio packages..."
    sudo dnf install -y \
        pipewire pipewire-pulseaudio pipewire-alsa \
        wireplumber pavucontrol blueman

    echo ""
    echo "[5/6] Installing development tools..."
    sudo dnf install -y \
        gcc gcc-c++ make cmake nodejs nodejs-npm python3 python3-pip \
        fzf zoxide yazi

    echo ""
    echo "[6/6] Installing Starship, Oh My Zsh and Zsh plugins..."
    if ! command -v starship &>/dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        echo "Starship already installed"
    fi

    if [[ ! -d ~/.oh-my-zsh ]]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    else
        echo "Oh My Zsh already installed"
    fi

    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugin
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
        if [[ ! -d "$zsh_custom/plugins/$plugin" ]]; then
            echo "Installing $plugin..."
            git clone --depth=1 "https://github.com/zsh-users/$plugin" "$zsh_custom/plugins/$plugin"
        fi
    done

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

stow_all() {
    local flag="$1" package
    # generated files that must not block stow
    rm -f ~/.config/gtk-3.0/bookmarks ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
    for package in "${PACKAGES[@]}"; do
        echo "Stowing $package..."
        stow $flag -t ~ "$package"
    done
    chmod +x ~/.config/waybar/scripts/*.sh
    write_gtk_bookmarks
    set_theme_symlinks "$THEME"
    setup_zsh
}

case "$1" in
    "deps")
        install_deps
        ;;
    "install")
        echo "Installing all dotfiles packages..."
        stow_all ""
        echo ""
        echo "All packages installed successfully!"
        echo ""
        echo "Open a new terminal for zsh changes."
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
        stow_all "-R"
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
        echo "  --bsod"
        echo "  --platinum"
        echo ""
        echo "Example (new machine setup):"
        echo "  $0 deps              # Install dependencies"
        echo "  $0 install           # Install dotfiles"
        echo "  chsh -s \$(which zsh)  # Set zsh as default shell"
        exit 1
        ;;
esac
