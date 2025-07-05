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

## Requirements

- GNU Stow (install with your package manager)
- The applications these dotfiles are for 