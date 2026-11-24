# Dotfiles - Hyprland on Fedora

Dotfiles managed with GNU Stow, optimized for Hyprland on Fedora.

## Quick Start (New Machine)

```bash
mkdir -p ~/realm/builds && cd ~/realm/builds
git clone <your-repo-url> dotfiles
cd dotfiles

./install.sh deps      # dnf packages, removes replaced GUI apps, builds the extras (sudo)
./install.sh install   # stow dotfiles, set theme, wire zsh/mime/portals
chsh -s $(which zsh)
# Log out, pick Hyprland at the login screen
```

## Commands

```bash
./install.sh deps                  # system dependencies + extras
./install.sh extras                # only the non-dnf tools (mise, sesh, lazydocker, bluetuith, pyprland, termfilechooser)
./install.sh install [--theme]     # install dotfiles (default: gruvbox)
./install.sh restow  [--theme]     # reinstall / switch theme (after pulling updates)
./install.sh uninstall             # remove the symlinks
```

Themes: `--gruvbox` `--monochrome`

## Terminal first

Everything day-to-day runs in kitty. GUI is the browser, the lock screen and the bar.

| Need | Tool | Open |
|---|---|---|
| terminal | kitty | `Super+Return`, `Super+`` ` dropdown, `Super+Shift+Return` floating |
| files | yazi | `Super+E`, `y` in a shell |
| editor | neovim | `Super+C`, `nvim` |
| sessions | tmux + sesh | `s` in a shell, `prefix T` |
| audio | wiremix | `Super+A` |
| network / bluetooth | nmtui / bluetuith | `Super+N` / `Super+Shift+N` |
| system | btop | `Super+I` |
| git / docker | lazygit / lazydocker | `lg` / `ld` |
| pdf / video / images | zathura / mpv / swayimg | `xdg-open`, yazi `Enter` |
| versions | mise | node, bun, python |
| history / env | atuin / direnv | `Ctrl+r` / `.envrc` |
| ls cat du df find grep | eza bat dust duf fd ripgrep | aliased |
| file dialogs | yazi (termfilechooser portal) | browser uploads open yazi |

Scratchpads (dropdown terminal, mixer, network, bluetooth, btop) are pyprland: one key shows, same key hides, the app keeps running.

## Helpers, so you never have to remember

| Where | Key | What |
|---|---|---|
| anywhere | `Super+/` | every Hyprland keybind, searchable, Enter runs it (parsed live from `keybinds.conf`) |
| anywhere | `Super+Shift+/` | cheat sheets in a floating window |
| shell | `cheat` | pick a sheet with fzf. `cheat hypr`, `cheat tmux`, `cheat nvim`, `cheat yazi`, `cheat shell`, `cheat git`, `cheat apps`, `cheat theme`. `cheat -e shell` edits |
| shell | `tldr cmd` | examples for any command |
| tmux | `prefix H` | tmux sheet |
| nvim | `Space` | which-key shows groups |
| yazi / lazygit / btop | `~` / `?` / `Esc` | built-in key help |

Sheets live in `cheats-stow/.config/cheats/*.md`. Add a bind to `keybinds.conf` with a trailing `# comment` and it appears in `Super+/` with that description.

## What gets installed

**Hyprland:** hyprland, waybar, mako, rofi, rofimoji, hyprpaper, hyprlock, hypridle, lxpolkit (polkit agent), xdg-desktop-portal-{hyprland,gtk}, cliphist, wl-clipboard, pyprland

**Terminal apps:** kitty, neovim, tmux, yazi, lazygit, lazydocker, btop, cava, fastfetch, zathura, mpv, swayimg, wiremix, bluetuith, NetworkManager-tui

**CLI:** zsh, oh-my-zsh, starship, fzf, zoxide, atuin, direnv, mise, eza, bat, fd, ripgrep, git-delta, dust, duf, tealdeer, jq, glow, chafa

**Media/system:** grim, slurp, wf-recorder, hyprpicker, ImageMagick, brightnessctl, playerctl, upower, pipewire, wireplumber

**Dev:** git, stow, gcc, gcc-c++, make, cmake, golang, python3

**Fonts:** JetBrainsMono Nerd Font, JetBrains Mono, Inter, Noto (sans, serif, emoji)

Removed by `deps` if present: alacritty, nautilus, pavucontrol, blueman, wofi.

### Stow packages

| Package | Description |
|---------|-------------|
| `btop-stow` | System monitor |
| `cava-stow` | Audio visualizer |
| `cheats-stow` | Cheat sheets for `cheat` and `Super+Shift+/` |
| `fastfetch-stow` | System info |
| `fontconfig-stow` | Font rendering |
| `git-stow` | delta dark feature (identity stays in `~/.gitconfig`) |
| `gtk3-stow`, `gtk4-stow` | GTK theme css, dark preference |
| `hypr-stow` | Hyprland, hyprpaper, hyprlock, hypridle, pyprland |
| `kitty-stow` | Terminal + 2 colour themes |
| `lazygit-stow` | lazygit + per-theme colours |
| `mako-stow` | Notifications |
| `mise-stow` | Global node/bun/python versions |
| `nvim-stow` | Neovim (lazy.nvim, LSP, treesitter) |
| `rofi-stow` | Launcher, menus, switcher grid |
| `starship-stow` | Prompt, one palette per theme |
| `tmux-stow` | tmux, sesh sessions, godmode layout |
| `waybar-stow` | Bar, scripts |
| `xdg-stow` | Default apps (`mimeapps.list`), terminal `.desktop` entries, portal config |
| `yazi-stow` | yazi flavors per theme |
| `zsh-stow` | `~/.zshenv` (sets `ZDOTDIR`), zsh config, aliases |

## Themes

Available: `gruvbox` (default), `monochrome`. `Super+Alt+T` switches live (kitty, waybar, rofi, hyprland, mako, gtk, nvim, zsh, fzf, bat, delta, glow, lazygit, starship, yazi, btop). `theme-apply.sh` is the one script that knows the list. From a terminal: `./install.sh restow --monochrome`. Details: `cheat theme`.

The bar has one layout (outline) and follows the colour theme. Wallpapers: `Super+Alt+W`.

## Key bindings

One meaning per modifier. `Super+/` shows the full list, searchable, Enter runs it.

| Layer | Meaning | Examples |
|---|---|---|
| `Super + key` | launch or toggle an app | `Return` terminal, `` ` `` dropdown, `Space` launcher, `E` yazi, `C` nvim, `B` browser, `A` mixer, `N` network, `I` btop, `.` emoji |
| `Super + Shift + key` | same app, alternate form | `Return` floating terminal, `E` floating yazi, `B` private browser, `N` bluetooth |
| window verbs | | `Q` close, `F` fullscreen, `V` float, `X` center, `O` pin, `G` group, `Tab` cycle, `h/j/k/l` focus (+Shift move, +Ctrl resize), `S` stash |
| workspaces | | `1-0` go (+Shift move), `[` `]` prev/next (+Shift move), `Esc` last |
| `Super + Alt + key` | system, rare | `L` lock, `M` power menu, `R` reload, `T`/`W` theme/wallpaper, `V` clipboard, `D` dismiss notifications, `C` colour picker, `Print` screen record |
| help | | `Super+/` keybinds, `Super+Shift+/` cheat sheets |
| `Print` | screenshots | `Print` region, `Shift+Print` full, `Ctrl+Print` window |

Add a bind to `keybinds.conf` with a trailing `# comment` and it appears in `Super+/` with that description.

## How zsh is wired

`zsh-stow` stows `~/.zshenv`, which sets `ZDOTDIR=~/.config/zsh`, so zsh loads the repo's `.zshrc` and ignores `~/.zshrc`. `install.sh` moves an existing `~/.zshrc` to `~/.zshrc.pre-dotfiles`.

Machine-specific config and secrets go in `~/.zshrc.local` (mode 600, created empty, sourced last). Never in the repo.

Versions come from mise (`~/.config/mise/config.toml`, per project `.mise.toml` / `.nvmrc`). conda stays available lazily for conda envs; its base is not on `PATH`.

## Idle and lock

hypridle dims at 4 min, locks at 5, screen off at 10, suspends at 30. `Super+Alt+L` locks now. `Super+Alt+M` is the power menu.

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

### Scratchpad keys do nothing
```bash
pypr exit; pypr &          # restart pyprland
pypr --help                # check it is installed (uv tool install pyprland)
```

### Browser file dialog is still GTK
```bash
ls /usr/libexec/xdg-desktop-portal-termfilechooser   # missing -> ./install.sh extras
systemctl --user restart xdg-desktop-portal
```

### Wrong app opens a file
```bash
xdg-mime query default inode/directory       # expect yazi.desktop
./install.sh restow                          # re-links ~/.config/mimeapps.list
```

### Fonts not showing icons
```bash
# Install a Nerd Font manually
# Download from: https://www.nerdfonts.com/font-downloads
mkdir -p ~/.local/share/fonts
# Extract font files to ~/.local/share/fonts/
fc-cache -fv
```

### Starship prompt not showing
```bash
# Install starship (deps does this)
curl -sS https://starship.rs/install.sh | sh
# Make sure ZDOTDIR is set: should print /home/<you>/.config/zsh
zsh -c 'echo $ZDOTDIR'
```

### Zsh aliases not working
```bash
# Re-stow so ~/.zshenv exists, then open a new shell
./install.sh restow
exec zsh
```

### Fix hardcoded paths (if cloned from someone else)
```bash
# Update paths from old user to current user
find . -type f -exec sed -i "s|/home/olduser|$HOME|g" {} \;
./install.sh restow
```

## Structure

```
dotfiles/
├── install.sh
├── README.md
├── wallpapers/              # current -> active wallpaper (gitignored)
├── cheats-stow/.config/cheats/*.md
├── hypr-stow/.config/hypr/  # hyprland, keybinds, windowrules, hypridle, hyprlock, pyprland.toml, themes/
├── kitty-stow/.config/kitty/{kitty.conf,themes/}
├── xdg-stow/                # mimeapps.list, .local/share/applications/*.desktop, portals.conf, termfilechooser wrapper
├── zsh-stow/{.zshenv,.config/zsh/}
└── ... (other *-stow packages)
```

Generated, gitignored: `waybar/config`, `gtk-*/gtk.css`, `gtk-*/settings.ini`, `gtk-3.0/bookmarks`, `zsh/dotfiles-theme.env`, `xdg-desktop-portal-termfilechooser/config`.

## Requirements

- Fedora 43+
- GNU Stow, sudo for `deps`
