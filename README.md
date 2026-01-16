# Dotfiles Management with GNU Stow

This repository contains dotfiles organized for easy management with GNU Stow, optimized for Hyprland on Fedora 43.

## Available Packages

- `alacritty-stow` - Alacritty terminal emulator configuration
- `cava-stow` - CAVA audio visualizer configuration
- `fontconfig-stow` - Font configuration and rendering settings
- `gtk3-stow` - GTK3 theme and application settings
- `gtk4-stow` - GTK4 theme and application settings
- `hypr-stow` - Hyprland window manager configuration
- `kitty-stow` - Kitty terminal emulator configuration
- `lazygit-stow` - LazyGit configuration
- `mako-stow` - Mako notification daemon configuration
- `nvim-stow` - Neovim configuration
- `rofi-stow` - Rofi application launcher configuration
- `tmux-stow` - Tmux terminal multiplexer configuration
- `waybar-stow` - Waybar status bar configuration
- `zsh-stow` - Zsh shell configuration (includes p10k, zoxide, fzf configs)

## Quick Installation

Use the provided installation script for easy management:

```bash
cd ~/realm/builds/dotfiles

# Install all packages
./install.sh install

# Uninstall all packages
./install.sh uninstall

# Restow all packages (uninstall then install)
./install.sh restow
```

## Theme System

This setup supports multiple themes across these apps:

- `alacritty`, `kitty`, `rofi`, `waybar`, `hyprland`, `mako`, `neovim`, `zsh` (fzf)

Available themes: `gruvbox` (default), `monochrome`, `catppuccin-mocha`

Wallpaper and GTK are intentionally not changed by theme switches.

### Switch themes

Gruvbox (default):
```bash
cd ~/realm/builds/dotfiles
./install.sh restow
```

Monochrome:
```bash
./install.sh restow --monochrome
```

Catppuccin Mocha:
```bash
./install.sh restow --catppuccin-mocha
```

You can also pass the flag on first install:
```bash
./install.sh install --monochrome
```

Under the hood, per-app symlinks like `~/.config/<app>/themes/current.*` are updated to point to the selected theme. `~/.config/zsh/dotfiles-theme.env` is written so Neovim and fzf pick up the current theme in new shells.

### Reload tips (no logout required)

- Waybar: `killall waybar && waybar &`
- Mako: `makoctl reload`
- Neovim/fzf in current shell:
  ```bash
  source ~/.config/zsh/dotfiles-theme.env
  source ~/.config/zsh/.zshrc
  ```
- Kitty/Alacritty/Rofi: open a new instance to see the theme
- Hyprland: theme applies to new windows; full reload optional

## Setting Up on a New Machine (Fedora 43)

This guide will help you set up these dotfiles on a fresh Fedora 43 installation that comes with GNOME by default.

### Prerequisites

- Fedora 43 installed (with GNOME)
- sudo/root access
- Internet connection

### Step 1: Install Required Packages

#### Install Hyprland and Core Dependencies

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

#### Install Fonts

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

#### Install Development Tools

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

#### Install Zsh Plugins and Tools

```bash
# Install zoxide (smart cd command)
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.local/share/powerlevel10k

# Install zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
```

#### Install Additional Development Tools

```bash
# Install FZF (Fuzzy Finder) - required for zsh fzf plugin
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install ranger (file manager)
sudo dnf install -y ranger

# Install lazydocker (Docker TUI) - optional
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" | tar xz -C ~/.local/bin lazydocker

# Install AWS CLI (if needed for AWS SSM aliases) - optional
pip3 install awscli --user
```

**Optional tools** (install if needed):
- **eza**: Modern ls replacement - `cargo install eza` or download from GitHub
- **lf**: File manager - `cargo install lf` or download from GitHub
- **Spicetify**: Spotify theming - `curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh`

**Note:** The dotfiles will automatically configure zoxide and p10k when you install them. The `.p10k.zsh` config file is included in the dotfiles.

### Step 2: Install GNU Stow

```bash
sudo dnf install -y stow
```

### Step 3: Clone Your Dotfiles

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

### Step 4: Install Dotfiles

```bash
# Make install script executable
chmod +x install.sh

# Install all dotfiles (default theme: gruvbox)
./install.sh install

# Or install with a specific theme:
# ./install.sh install --monochrome
# ./install.sh install --catppuccin-mocha
```

**Note:** The dotfiles include:
- **Powerlevel10k (p10k) configuration** - The `.p10k.zsh` file is included and will be symlinked to `~/.p10k.zsh`
- **Zoxide configuration** - Zoxide is initialized in `plugins.zsh` with the alias `j='z'` for quick directory jumping
- **FZF configuration** - Theme-aware FZF colors configured in `.zshrc`
- **zsh-highlight-config.zsh** - Custom syntax highlighting colors
- All zsh plugins are configured automatically

### Step 5: Set Up Hyprland Session

#### Option A: Keep GNOME and Add Hyprland (Recommended)

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

#### Option B: Replace GNOME with Hyprland (Advanced)

**Warning:** This will make Hyprland the default session. You can still access GNOME by selecting it at login.

### Step 6: Configure Display Manager (GDM)

Fedora uses GDM by default. You should be able to select Hyprland from the session menu at login. If not:

```bash
# Ensure GDM is configured to show Wayland sessions
sudo systemctl enable gdm
sudo systemctl start gdm
```

### Step 7: Install Additional Tools (Optional)

#### Audio/Video
```bash
sudo dnf install -y \
    pipewire \
    pipewire-pulseaudio \
    pipewire-alsa \
    wireplumber \
    pavucontrol \
    blueman
```

#### Screenshot/Recording
```bash
sudo dnf install -y \
    grim \
    slurp \
    wf-recorder \
    imagemagick
```

### Step 8: Fix Path Issues in Configs

Some configs have hardcoded paths. Update them:

```bash
cd ~/realm/builds/dotfiles
sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprlock.conf
sed -i "s|/home/dmann|$HOME|g" hypr-stow/.config/hypr/hyprpaper.conf
./install.sh restow
```

### Step 9: Set Default Shell to Zsh

```bash
# Install zsh if not already installed
sudo dnf install -y zsh

# Set zsh as default shell
chsh -s $(which zsh)

# Log out and log back in, or run:
exec zsh
```

**Note:** After setting zsh as default and installing the dotfiles:
- **Powerlevel10k** will be automatically configured with your saved theme
- **Zoxide** will be initialized - use `z <directory>` or `j <directory>` to jump to frequently used directories
- **FZF** will be available for fuzzy finding
- All zsh plugins (autosuggestions, syntax highlighting, etc.) will be active

### Step 10: Start Hyprland

#### From GNOME Session
1. Log out of GNOME
2. At the login screen, click your username
3. Click the gear icon (⚙️) or session selector
4. Select "Hyprland"
5. Enter your password and log in

#### From TTY (if display manager fails)
```bash
# Press Ctrl+Alt+F2 (or F3-F6) to switch to TTY
# Log in, then run:
exec Hyprland
```

## Tools Included in This Setup

### Core Applications
- **Hyprland** - Wayland compositor/window manager
- **Waybar** - Status bar
- **Mako** - Notification daemon
- **Rofi** - Application launcher
- **Alacritty/Kitty** - Terminal emulators
- **Neovim** - Text editor
- **Tmux** - Terminal multiplexer
- **LazyGit** - Git TUI
- **CAVA** - Audio visualizer

### Shell & Terminal Tools
- **Zsh** - Shell with Oh My Zsh
- **Powerlevel10k (p10k)** - Zsh theme (config included)
- **Zoxide** - Smart cd command (`z` or `j` alias)
- **FZF** - Fuzzy finder (theme-aware)
- **Oh My Zsh plugins**:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-history-substring-search
  - fzf plugin
  - eza plugin (if installed)

### Development Tools
- **NVM** - Node Version Manager
- **Lazydocker** - Docker TUI (optional)
- **Ranger** - File manager
- **AWS CLI** - For AWS SSM aliases (optional)

### Optional Tools
- **eza** - Modern ls replacement
- **lf** - File manager
- **Spicetify** - Spotify theming
- **Cursor IDE** - AppImage (place in `~/Applications/`)

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

### Powerlevel10k (p10k) not displaying correctly
```bash
# Check if p10k is installed
ls -la ~/.local/share/powerlevel10k/

# Check if config file exists
ls -la ~/.p10k.zsh

# If config is missing, reinstall dotfiles
cd ~/realm/builds/dotfiles
./install.sh restow

# Reconfigure p10k (optional - will overwrite your saved config)
p10k configure
```

### Zoxide not working
```bash
# Check if zoxide is installed
which zoxide

# Add to PATH if installed to ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Reinitialize zoxide
eval "$(zoxide init zsh)"
```

### FZF not working
```bash
# Check if FZF is installed
ls -la ~/.fzf

# Reinstall FZF if needed
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Reload zsh config
source ~/.config/zsh/.zshrc
```

### NVM not working
```bash
# Check if NVM is installed
ls -la ~/.nvm

# Reinstall NVM if needed
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell or source NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install a Node version
nvm install --lts
```

## Personal Configuration Notes

After installing the dotfiles, you may need to configure:

1. **SSH Keys**: The `.zshrc` references `~/.ssh/id_ed25519_vamaship`. Update this path or create the key:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_vamaship -C "your_email@example.com"
   ```

2. **AWS CLI**: If you use AWS SSM aliases, install and configure AWS CLI:
   ```bash
   pip3 install awscli --user
   aws configure
   ```

3. **Cursor IDE**: Download Cursor AppImage and place it at `~/Applications/cursor.AppImage`:
   ```bash
   mkdir -p ~/Applications
   # Download from cursor.sh and place in ~/Applications/
   ```

4. **Spicetify** (optional): If you use Spotify theming:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
   ```

5. **Custom completion functions**: If you have custom completions in `~/.zfunc`, copy them manually.

6. **Hardcoded paths**: Some configs have hardcoded paths. Update:
   - `~/.config/zsh/.zshrc` - SSH key path, spicetify path
   - `~/.config/hypr/hyprlock.conf` - Wallpaper and profile image paths
   - `~/.config/hypr/hyprpaper.conf` - Wallpaper paths

## Manual Installation

### Install all packages:
```bash
cd ~/realm/builds/dotfiles
stow -t ~ alacritty-stow cava-stow fontconfig-stow gtk3-stow gtk4-stow hypr-stow kitty-stow lazygit-stow mako-stow nvim-stow rofi-stow tmux-stow waybar-stow zsh-stow
```

### Install individual packages:
```bash
cd ~/realm/builds/dotfiles
stow -t ~ alacritty-stow    # Install Alacritty config
stow -t ~ nvim-stow         # Install Neovim config
stow -t ~ hypr-stow         # Install Hyprland config
# etc...
```

### Uninstall packages:
```bash
cd ~/realm/builds/dotfiles
stow -D -t ~ alacritty-stow    # Uninstall Alacritty config
stow -D -t ~ nvim-stow         # Uninstall Neovim config
# etc...
```

## Adding New Packages

To add a new package:

1. Create a new directory with the package name + `-stow` suffix
2. Create the proper directory structure that mirrors the target location
3. Place the configuration files in the appropriate subdirectories

Example for a new package called `myapp`:
```bash
mkdir -p myapp-stow/.config
# Place myapp config files in myapp-stow/.config/myapp/
```

## Notes

- All packages are structured to install to `~/.config/` by default
- Use `stow -n -t ~ package-name` to do a dry run and see what would be installed
- Use `stow -v -t ~ package-name` for verbose output
- The `-t ~` flag specifies the target directory (your home directory)
- GNOME and Hyprland can coexist - you don't need to remove GNOME
- Some GNOME apps (like Nautilus) will work fine in Hyprland
- You may need to adjust monitor settings in `~/.config/hypr/hyprland.conf` for your display setup

## Requirements

- GNU Stow (install with your package manager)
- The applications these dotfiles are for (see Tools Included section above)

## Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [Wayland Documentation](https://wayland.freedesktop.org/)
