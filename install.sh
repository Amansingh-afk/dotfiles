#!/bin/bash

# Dotfiles installation script using GNU Stow
# Optimized for Hyprland on Fedora

set -eo pipefail
cd "$(dirname "$(readlink -f "$0")")"

PACKAGES=(
    "btop-stow"
    "cava-stow"
    "cheats-stow"
    "fastfetch-stow"
    "fontconfig-stow"
    "git-stow"
    "gtk3-stow"
    "gtk4-stow"
    "hypr-stow"
    "kitty-stow"
    "lazygit-stow"
    "mako-stow"
    "mise-stow"
    "nvim-stow"
    "rofi-stow"
    "starship-stow"
    "tmux-stow"
    "waybar-stow"
    "xdg-stow"
    "yazi-stow"
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
    ~/.config/waybar/scripts/theme-apply.sh "$theme"
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

remove_gui() {
    # GUI apps replaced by TUIs: yazi, wiremix, bluetuith, nmtui. Terminal is kitty.
    local p rm=()
    for p in alacritty nautilus pavucontrol blueman wofi; do
        rpm -q "$p" &>/dev/null && rm+=("$p")
    done
    if ((${#rm[@]})); then
        echo "Removing replaced GUI apps: ${rm[*]}"
        sudo dnf remove -y "${rm[@]}"
    fi
}

install_extras() {
    # Tools not packaged in Fedora
    echo ""
    echo "Installing mise, sesh, lazydocker, bluetuith, pyprland, termfilechooser..."
    if ! command -v mise &>/dev/null && [[ ! -x ~/.local/bin/mise ]]; then
        curl -fsSL https://mise.run | sh
    fi
    export PATH="$HOME/go/bin:$HOME/.local/bin:$PATH"
    command -v sesh       &>/dev/null || GOTOOLCHAIN=auto go install github.com/joshmedeski/sesh/v2@latest
    command -v lazydocker &>/dev/null || go install github.com/jesseduffield/lazydocker@latest
    command -v bluetuith  &>/dev/null || go install github.com/darkhz/bluetuith@latest
    if ! command -v pypr &>/dev/null; then
        if command -v uv &>/dev/null; then uv tool install pyprland
        else python3 -m pip install --user pyprland; fi
    fi
    install_termfilechooser || echo "Warning: termfilechooser build failed, file dialogs stay GTK"
}

install_termfilechooser() {
    # xdg-desktop-portal backend that opens yazi for file dialogs (not packaged in Fedora)
    [[ -x /usr/libexec/xdg-desktop-portal-termfilechooser ]] && { echo "termfilechooser already installed"; return 0; }
    local tmp
    tmp=$(mktemp -d)
    git clone --depth=1 https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser "$tmp/src"
    (
        cd "$tmp/src"
        meson setup build --prefix=/usr -Dsd-bus-provider=libsystemd
        ninja -C build
        sudo ninja -C build install
    )
    rm -rf "$tmp"
    systemctl --user daemon-reload
    systemctl --user restart xdg-desktop-portal 2>/dev/null || true
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
        cliphist wl-clipboard rofimoji \
        qt6-qtbase qt6ct gtk4 gtk3 \
        kitty kitty-terminfo neovim zsh tmux lazygit btop cava fastfetch fontconfig \
        stow git curl unzip

    echo ""
    echo "[1b/6] Installing terminal apps and CLI tools..."
    sudo dnf install -y \
        yazi zathura zathura-pdf-mupdf zathura-cb mpv swayimg wiremix NetworkManager-tui \
        eza bat fd-find ripgrep git-delta du-dust duf tealdeer atuin direnv jq glow chafa \
        ffmpegthumbnailer poppler-utils p7zip \
        meson ninja-build inih-devel systemd-devel scdoc pkgconf

    echo ""
    echo "[2/6] Installing fonts..."
    sudo dnf install -y google-noto-sans-fonts google-noto-serif-fonts google-noto-color-emoji-fonts jetbrains-mono-fonts-all rsms-inter-fonts
    install_nerd_font
    install_vt323_font

    echo ""
    echo "[3/6] Installing screenshot and media tools..."
    sudo dnf install -y \
        grim slurp wf-recorder hyprpicker ImageMagick \
        brightnessctl playerctl upower

    echo ""
    echo "[4/6] Installing audio packages..."
    sudo dnf install -y \
        pipewire pipewire-pulseaudio pipewire-alsa \
        wireplumber pavucontrol blueman

    echo ""
    echo "[5/6] Installing development tools..."
    sudo dnf install -y \
        gcc gcc-c++ make cmake golang python3 python3-pip \
        fzf zoxide

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

    remove_gui
    install_extras

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

write_hypr_env() {
    # Hyprland starts with PATH=/usr/local/bin:/usr/bin. Everything it launches (keybinds, waybar,
    # pyprland, kitty) needs the user tool dirs too. env= needs absolute paths, so generate it.
    cat > ~/.config/hypr/env.conf <<ENV
# Generated by install.sh, do not edit (gitignored)
env = PATH,$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:/usr/bin
ENV
}

setup_xdg() {
    # termfilechooser config needs absolute paths, so it is generated (gitignored)
    cat > ~/.config/xdg-desktop-portal-termfilechooser/config <<CFG
[filechooser]
cmd=$HOME/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
default_dir=$HOME
env=TERMCMD=kitty --class tui-float
CFG
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
    systemctl --user restart xdg-desktop-portal 2>/dev/null || true
}

stow_all() {
    local flag="$1" package
    # generated files that must not block stow
    rm -f ~/.config/gtk-3.0/bookmarks ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
    rm -f ~/.config/btop/btop.conf ~/.config/starship.toml
    # files other tools wrote before we owned them
    if [[ -f ~/.config/mimeapps.list && ! -L ~/.config/mimeapps.list ]]; then
        mv ~/.config/mimeapps.list ~/.config/mimeapps.list.pre-dotfiles
        echo "Moved old ~/.config/mimeapps.list to ~/.config/mimeapps.list.pre-dotfiles"
    fi
    mkdir -p ~/.local/share/applications ~/.config/xdg-desktop-portal
    for package in "${PACKAGES[@]}"; do
        echo "Stowing $package..."
        stow $flag -t ~ "$package"
    done
    chmod +x ~/.config/waybar/scripts/*.sh
    write_gtk_bookmarks
    set_theme_symlinks "$THEME"
    setup_zsh
    setup_xdg
    write_hypr_env
    export PATH="$HOME/.local/bin:$PATH"
    command -v mise &>/dev/null && mise install -y
    command -v tldr &>/dev/null && tldr --update >/dev/null 2>&1 || true
}

case "$1" in
    "deps")
        install_deps
        ;;
    "extras")
        install_extras
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
        echo "Usage: $0 {deps|extras|install|uninstall|restow} [--theme]"
        echo ""
        echo "Commands:"
        echo "  deps      - Install all system dependencies (run first on new machine)"
        echo "  extras    - Only the non-dnf tools (mise, sesh, lazydocker, bluetuith, pyprland, termfilechooser)"
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
