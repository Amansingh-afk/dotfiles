#!/bin/bash

# Fedora 43 Setup Script for Hyprland Dotfiles
# This script installs all required packages for the dotfiles setup

set -e

echo "=========================================="
echo "Fedora 43 Hyprland Setup Script"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run this script as root/sudo"
   echo "It will prompt for sudo when needed"
   exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[X]${NC} $1"
}

# Update system
print_status "Updating system packages..."
sudo dnf update -y

# Install Hyprland and core dependencies
print_status "Installing Hyprland and core Wayland packages..."
sudo dnf install -y \
    hyprland \
    waybar \
    mako \
    rofi \
    wofi \
    hyprpaper \
    hyprlock \
    cliphist \
    wl-clipboard \
    polkit-gnome \
    qt6-qtbase \
    qt6ct \
    gtk4 \
    gtk3 \
    nautilus \
    alacritty \
    kitty \
    neovim \
    zsh \
    tmux \
    lazygit \
    cava \
    fontconfig

# Install fonts
print_status "Installing fonts..."
sudo dnf install -y \
    fontawesome-fonts \
    powerline-fonts \
    google-noto-fonts

# Install development tools
print_status "Installing development tools..."
sudo dnf install -y \
    git \
    stow \
    gcc \
    g++ \
    make \
    cmake \
    nodejs \
    npm \
    python3 \
    python3-pip

# Install audio/video tools
print_status "Installing audio/video tools..."
sudo dnf install -y \
    pipewire \
    pipewire-pulseaudio \
    pipewire-alsa \
    wireplumber \
    pavucontrol \
    blueman

# Install screenshot/recording tools
print_status "Installing screenshot/recording tools..."
sudo dnf install -y \
    grim \
    slurp \
    wf-recorder \
    imagemagick

# Install zsh plugins and tools
print_status "Installing zsh plugins and tools..."

# Install zoxide
if ! command -v zoxide &> /dev/null; then
    print_status "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    # Add zoxide to PATH if installed to ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
else
    print_status "zoxide already installed"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_status "Oh My Zsh already installed"
fi

# Install Powerlevel10k
if [ ! -d "$HOME/.local/share/powerlevel10k" ]; then
    print_status "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/powerlevel10k
else
    print_status "Powerlevel10k already installed"
fi

# Install zsh plugins
print_status "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
fi

# Create Hyprland desktop entry
print_status "Creating Hyprland desktop entry..."
mkdir -p ~/.local/share/wayland-sessions
cat > ~/.local/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland compositor
Exec=/usr/bin/Hyprland
Type=Application
DesktopNames=Hyprland
EOF

print_status "Desktop entry created at ~/.local/share/wayland-sessions/hyprland.desktop"

# Check if dotfiles are already cloned
if [ ! -d "$HOME/realm/builds/dotfiles" ]; then
    print_warning "Dotfiles directory not found at ~/realm/builds/dotfiles"
    print_warning "Please clone your dotfiles repository:"
    echo "  mkdir -p ~/realm/builds"
    echo "  cd ~/realm/builds"
    echo "  git clone <your-repo-url> dotfiles"
    echo "  cd dotfiles"
    echo "  ./install.sh install"
else
    print_status "Found dotfiles directory at ~/realm/builds/dotfiles"
    read -p "Do you want to install the dotfiles now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd ~/realm/builds/dotfiles
        
        # Fix hardcoded paths in configs
        print_status "Fixing hardcoded paths in configs..."
        if [ -f "hypr-stow/.config/hypr/hyprlock.conf" ]; then
            sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprlock.conf
        fi
        if [ -f "hypr-stow/.config/hypr/hyprpaper.conf" ]; then
            sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprpaper.conf
        fi
        
        # Install dotfiles
        print_status "Installing dotfiles..."
        chmod +x install.sh
        ./install.sh install
        
        print_status "Dotfiles installed successfully!"
    fi
fi

echo ""
print_status "Setup complete!"
echo ""
print_warning "Next steps:"
echo "  1. Log out of your current session"
echo "  2. At the login screen, click the gear icon (⚙️)"
echo "  3. Select 'Hyprland' from the session menu"
echo "  4. Log in"
echo ""
print_warning "If Hyprland doesn't appear in the session menu, try:"
echo "  - Restarting GDM: sudo systemctl restart gdm"
echo "  - Checking logs: journalctl -u gdm -f"
echo ""
print_status "For more detailed instructions, see FEDORA_SETUP.md"
