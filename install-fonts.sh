#!/bin/bash
# Quick script to install Nerd Fonts for waybar icons

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

echo "Installing Nerd Fonts for waybar icons..."

# Check if already installed
if fc-list | grep -qi "nerd font\|jetbrains.*nerd"; then
    echo "Nerd Fonts already installed!"
    exit 0
fi

# Try to download JetBrains Mono Nerd Font
cd /tmp
echo "Downloading JetBrains Mono Nerd Font..."

if command -v wget &> /dev/null; then
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O nerd-font.zip
elif command -v curl &> /dev/null; then
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o nerd-font.zip
else
    echo "Error: wget or curl required. Please install one of them."
    exit 1
fi

if [ -f nerd-font.zip ]; then
    echo "Extracting fonts..."
    unzip -q nerd-font.zip -d "$FONT_DIR" 2>/dev/null || {
        echo "Error: unzip required. Installing..."
        sudo dnf install -y unzip
        unzip -q nerd-font.zip -d "$FONT_DIR"
    }
    rm -f nerd-font.zip
    
    echo "Updating font cache..."
    fc-cache -fv "$FONT_DIR"
    
    echo ""
    echo "✓ Nerd Fonts installed successfully!"
    echo "  Fonts installed to: $FONT_DIR"
    echo ""
    echo "Restart waybar to see icons:"
    echo "  killall waybar && waybar &"
else
    echo "Error: Could not download Nerd Fonts."
    echo "Please install manually from: https://www.nerdfonts.com/font-downloads"
    exit 1
fi
