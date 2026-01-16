# Dotfiles - Hyprland on Fedora

Dotfiles managed with GNU Stow, optimized for Hyprland on Fedora.

## Quick Start (New Machine)

```bash
# Clone the repo
mkdir -p ~/realm/builds && cd ~/realm/builds
git clone <your-repo-url> dotfiles
cd dotfiles

# Install everything
./install.sh deps      # Install all dependencies (requires sudo)
./install.sh install   # Install dotfiles

# Set zsh as default shell
chsh -s $(which zsh)

# Log out and log back in, then select Hyprland at login screen
```

## Commands

```bash
./install.sh deps              # Install system dependencies
./install.sh install           # Install dotfiles (default: gruvbox theme)
./install.sh install --monochrome      # Install with monochrome theme
./install.sh install --catppuccin-mocha # Install with catppuccin theme
./install.sh uninstall         # Remove dotfiles
./install.sh restow            # Reinstall (useful after pulling updates)
```

## What Gets Installed

### `./install.sh deps` installs:

**Hyprland & Wayland:**
- hyprland, waybar, mako, rofi, wofi, hyprpaper, hyprlock
- cliphist, wl-clipboard, polkit-gnome

**Apps:**
- alacritty, neovim, tmux, lazygit, cava, ranger, nautilus

**Zsh:**
- zsh, oh-my-zsh, powerlevel10k
- zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search
- fzf, zoxide

**Utils:**
- grim, slurp (screenshots), pamixer, brightnessctl, playerctl
- pipewire, pavucontrol, blueman

**Dev tools:**
- git, stow, gcc, make, cmake, nodejs, npm, python3

**Fonts:**
- fontawesome-fonts, powerline-fonts, google-noto-fonts

### `./install.sh install` configures:

| Package | Description |
|---------|-------------|
| `alacritty-stow` | Terminal emulator |
| `cava-stow` | Audio visualizer |
| `fontconfig-stow` | Font rendering |
| `gtk3-stow` | GTK3 theme settings |
| `gtk4-stow` | GTK4 theme settings |
| `hypr-stow` | Hyprland, hyprpaper, hyprlock |
| `lazygit-stow` | Git TUI |
| `mako-stow` | Notification daemon |
| `nvim-stow` | Neovim config |
| `rofi-stow` | App launcher |
| `tmux-stow` | Terminal multiplexer |
| `waybar-stow` | Status bar |
| `zsh-stow` | Zsh config, aliases, p10k |

## Themes

Available themes: `gruvbox` (default), `monochrome`, `catppuccin-mocha`

Switch themes:
```bash
./install.sh restow --monochrome
./install.sh restow --catppuccin-mocha
./install.sh restow --gruvbox
```

Reload after switching:
```bash
hyprctl reload
killall waybar && waybar &
makoctl reload
source ~/.zshrc
```

## Key Bindings (Hyprland)

| Shortcut | Action |
|----------|--------|
| `Super + Return` | Terminal (alacritty) |
| `Super + Space` | App launcher (rofi) |
| `Super + Q` | Close window |
| `Super + M` | Exit Hyprland |
| `Super + E` | File manager |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + H/J/K/L` | Move focus (vim keys) |
| `Super + Shift + H/J/K/L` | Move window |
| `Print` | Screenshot (region) |

## Zsh Aliases

```bash
ll          # ls -lah
lg          # lazygit
tm          # tmux
tma         # tmux attach
tmn <name>  # tmux new -s <name>
j <dir>     # zoxide jump
godmode     # Custom tmux layout
please      # sudo last command
```

## Troubleshooting

### Hyprland not in login menu
```bash
mkdir -p ~/.local/share/wayland-sessions
cat > ~/.local/share/wayland-sessions/hyprland.desktop << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland compositor
Exec=/usr/bin/Hyprland
Type=Application
DesktopNames=Hyprland
EOF
```

### Waybar not starting
```bash
chmod +x ~/.config/waybar/scripts/*.sh
waybar &
```

### Fonts not showing icons
```bash
# Install a Nerd Font manually
# Download from: https://www.nerdfonts.com/font-downloads
mkdir -p ~/.local/share/fonts
# Extract font files to ~/.local/share/fonts/
fc-cache -fv
```

### Powerlevel10k not working
```bash
# Ensure it's installed
ls ~/.local/share/powerlevel10k/

# If missing, install:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/powerlevel10k

# Reconfigure (optional)
p10k configure
```

### Zsh aliases not working
```bash
# Re-run install to add config to .zshrc
./install.sh install
source ~/.zshrc
```

### Fix hardcoded paths (if cloned from someone else)
```bash
# Update paths from old user to current user
find . -type f -exec sed -i "s|/home/olduser|$HOME|g" {} \;
./install.sh restow
```

## Manual Package Install

If you prefer to install packages individually:
```bash
cd ~/realm/builds/dotfiles
stow -t ~ alacritty-stow
stow -t ~ hypr-stow
# etc...
```

## Structure

```
dotfiles/
├── install.sh           # Main installation script
├── README.md
├── wallpapers/          # Wallpaper images
│   └── current -> ...   # Symlink to active wallpaper
├── alacritty-stow/
│   └── .config/alacritty/
├── hypr-stow/
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── keybinds.conf
│       ├── windowrules.conf
│       └── themes/
└── ... (other *-stow packages)
```

## Requirements

- Fedora 43+ (or any distro with Hyprland support)
- GNU Stow
- sudo access for dependency installation
