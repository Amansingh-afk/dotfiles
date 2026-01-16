# Setting Up Hyprland on Fedora 43

This guide will help you set up Hyprland on a fresh Fedora 43 installation that comes with GNOME by default.

## Prerequisites

You'll need:
- Fedora 43 installed (with GNOME)
- sudo/root access
- Internet connection

## Step 1: Install Required Packages

### Install Hyprland and Core Dependencies

```bash
# Update system
sudo dnf update -y

# Install Hyprland and essential Wayland packages
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
```

### Install Fonts (if needed)

```bash
# Install Nerd Fonts (for icons in waybar, neovim, etc.)
sudo dnf install -y \
    fontawesome-fonts \
    powerline-fonts \
    google-noto-fonts

# Or install JetBrains Mono Nerd Font manually:
# Download from: https://www.nerdfonts.com/font-downloads
# Extract to ~/.local/share/fonts/ and run: fc-cache -fv
```

### Install Development Tools (if needed)

```bash
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
```

## Step 2: Install GNU Stow

```bash
sudo dnf install -y stow
```

## Step 3: Clone Your Dotfiles

```bash
# Create a directory for your dotfiles
mkdir -p ~/realm/builds
cd ~/realm/builds

# Clone your dotfiles repository
git clone <your-repo-url> dotfiles
# Or if you're using SSH:
# git clone git@github.com:yourusername/dotfiles.git dotfiles

cd dotfiles
```

## Step 4: Install Dotfiles

```bash
# Make install script executable
chmod +x install.sh

# Install all dotfiles (default theme: gruvbox)
./install.sh install

# Or install with a specific theme:
# ./install.sh install --monochrome
# ./install.sh install --catppuccin-mocha
```

## Step 5: Set Up Hyprland Session

### Option A: Keep GNOME and Add Hyprland (Recommended)

This allows you to choose between GNOME and Hyprland at login:

```bash
# Create Hyprland desktop entry
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

### Option B: Replace GNOME with Hyprland (Advanced)

**Warning:** This will make Hyprland the default session. You can still access GNOME by selecting it at login.

```bash
# Set Hyprland as default (optional)
# Edit ~/.config/wayland-sessions or use your display manager settings
```

## Step 6: Configure Display Manager (GDM)

Fedora uses GDM by default. You should be able to select Hyprland from the session menu at login. If not:

```bash
# Ensure GDM is configured to show Wayland sessions
sudo systemctl enable gdm
sudo systemctl start gdm
```

## Step 7: Install Additional Tools (Optional)

### Audio/Video
```bash
sudo dnf install -y \
    pipewire \
    pipewire-pulseaudio \
    pipewire-alsa \
    wireplumber \
    pavucontrol \
    blueman
```

### Screenshot/Recording
```bash
sudo dnf install -y \
    grim \
    slurp \
    wf-recorder \
    imagemagick
```

### File Manager (if not using Nautilus)
```bash
sudo dnf install -y \
    thunar \
    nemo
```

## Step 8: Fix Path Issues in Configs

Some configs have hardcoded paths. Update them:

### Update hyprlock.conf
```bash
# Edit the wallpaper and profile image paths
nano ~/.config/hypr/hyprlock.conf
# Change paths from /home/dmann/... to your home directory
```

### Update hyprpaper.conf
```bash
# Edit the wallpaper path
nano ~/.config/hypr/hyprpaper.conf
# Change paths from /home/dmann/... to your home directory
```

Or use sed to replace automatically:
```bash
cd ~/realm/builds/dotfiles
sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprlock.conf
sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprpaper.conf
./install.sh restow
```

## Step 9: Set Default Shell to Zsh (Optional)

```bash
# Install zsh if not already installed
sudo dnf install -y zsh

# Set zsh as default shell
chsh -s $(which zsh)

# Log out and log back in, or run:
exec zsh
```

## Step 10: Start Hyprland

### From GNOME Session
1. Log out of GNOME
2. At the login screen, click your username
3. Click the gear icon (⚙️) or session selector
4. Select "Hyprland"
5. Enter your password and log in

### From TTY (if display manager fails)
```bash
# Press Ctrl+Alt+F2 (or F3-F6) to switch to TTY
# Log in, then run:
startx /usr/bin/Hyprland
# Or:
exec Hyprland
```

## Troubleshooting

### Hyprland doesn't appear in session menu
```bash
# Check if desktop file exists
ls -la ~/.local/share/wayland-sessions/

# Verify Hyprland is installed
which Hyprland

# Check GDM logs
journalctl -u gdm -f
```

### Waybar not starting
```bash
# Check waybar config
waybar -c ~/.config/waybar/config

# Make scripts executable
chmod +x ~/.config/waybar/scripts/*.sh
```

### Fonts not displaying correctly
```bash
# Rebuild font cache
fc-cache -fv

# Check if fonts are installed
fc-list | grep -i "nerd\|jetbrains"
```

### Audio not working
```bash
# Restart pipewire
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check audio devices
pactl list short sinks
```

### Clipboard not working
```bash
# Ensure cliphist is running
ps aux | grep cliphist

# Start cliphist manually
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
```

### Polkit authentication not working
```bash
# Ensure polkit-gnome is running
ps aux | grep polkit-gnome

# Start manually if needed
/usr/libexec/polkit-gnome-authentication-agent-1 &
```

## Post-Installation Checklist

- [ ] All dotfiles installed successfully
- [ ] Hyprland session appears in login menu
- [ ] Waybar displays correctly
- [ ] Mako notifications work
- [ ] Rofi launcher works
- [ ] Audio works
- [ ] Fonts display correctly
- [ ] Clipboard manager works
- [ ] Wallpapers load correctly
- [ ] All keybinds work as expected

## Switching Back to GNOME

If you need to switch back to GNOME:
1. Log out of Hyprland
2. At login screen, select "GNOME" or "GNOME on Xorg" from session menu
3. Log in

## Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [Wayland Documentation](https://wayland.freedesktop.org/)

## Notes

- GNOME and Hyprland can coexist - you don't need to remove GNOME
- Some GNOME apps (like Nautilus) will work fine in Hyprland
- You may need to adjust monitor settings in `~/.config/hypr/hyprland.conf` for your display setup
- Update wallpaper paths in `hyprlock.conf` and `hyprpaper.conf` to match your setup
