# Dotfiles Management with GNU Stow

This repository contains dotfiles organized for easy management with GNU Stow.

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
- `zsh-stow` - Zsh shell configuration

## Quick Installation

Use the provided installation script for easy management:

```bash
cd /home/dmann/realm/builds/dotfiles

# Install all packages
./install.sh install

# Uninstall all packages
./install.sh uninstall

# Restow all packages (uninstall then install)
./install.sh restow
```

## Theme System (Gruvbox default + Monochrome)

This setup supports multiple themes across these apps:

- `alacritty`, `kitty`, `rofi`, `waybar`, `hyprland`, `mako`, `neovim`, `zsh` (fzf)

Wallpaper and GTK are intentionally not changed by theme switches.

### Switch themes

Gruvbox (default):

```bash
cd /home/dmann/realm/builds/dotfiles
./install.sh restow
```

Monochrome:

```bash
cd /home/dmann/realm/builds/dotfiles
./install.sh restow --monochrome
```

You can also pass the flag on first install:

```bash
./install.sh install --monochrome
```

Under the hood, per-app symlinks like `~/.config/<app>/themes/current.*` are updated to point to the selected theme (e.g., `gruvbox` or `monochrome`). `~/.config/zsh/dotfiles-theme.env` is written so Neovim and fzf pick up the current theme in new shells.

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

## Manual Installation

### Install all packages:
```bash
cd /home/dmann/realm/builds/dotfiles
stow -t ~ alacritty-stow cava-stow fontconfig-stow gtk3-stow gtk4-stow hypr-stow kitty-stow lazygit-stow mako-stow nvim-stow rofi-stow tmux-stow waybar-stow zsh-stow
```

### Install individual packages:
```bash
cd /home/dmann/realm/builds/dotfiles
stow -t ~ alacritty-stow    # Install Alacritty config
stow -t ~ nvim-stow         # Install Neovim config
stow -t ~ hypr-stow         # Install Hyprland config
# etc...
```

### Uninstall packages:
```bash
cd /home/dmann/realm/builds/dotfiles
stow -D -t ~ alacritty-stow    # Uninstall Alacritty config
stow -D -t ~ nvim-stow         # Uninstall Neovim config
# etc...
```

### Uninstall all packages:
```bash
cd /home/dmann/realm/builds/dotfiles
stow -D -t ~ alacritty-stow cava-stow fontconfig-stow gtk3-stow gtk4-stow hypr-stow kitty-stow lazygit-stow mako-stow nvim-stow rofi-stow tmux-stow waybar-stow zsh-stow
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

## Setting Up on a New Machine

For detailed instructions on setting up this dotfiles repository on a fresh Fedora 43 installation (including installing Hyprland alongside GNOME), see [FEDORA_SETUP.md](FEDORA_SETUP.md).

Quick start:
1. Install required packages (see FEDORA_SETUP.md)
2. Clone this repository
3. Run `./install.sh install`

## Requirements

- GNU Stow (install with your package manager)
- The applications these dotfiles are for 