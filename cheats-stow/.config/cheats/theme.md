# Themes, bar layouts, wallpapers

Themes: `gruvbox` (default), `monochrome`, `catppuccin-mocha`, `bsod`, `platinum` (light).

## Switch
| How | What |
|---|---|
| `Super+Alt+T` | theme cards (rofi) |
| `Super+Alt+B` | waybar layout cards |
| `Super+Alt+W` | wallpaper cards (plus Random) |
| `./install.sh restow --monochrome` | from terminal, also re-links everything |
| `~/.config/waybar/scripts/waybar-layout.sh floating` | layout only |

Layouts: `default`, `outline`, `floating`, `bsod`, `platinum`. Colour theme and layout are independent; picking a theme keeps a standalone layout (outline, floating).

## What a theme touches
| App | File |
|---|---|
| kitty | `kitty/themes/<t>.conf` → `current.conf` (running kitties reload) |
| hyprland | `hypr/themes/<t>.conf` (borders, blur, animations) |
| waybar | `waybar/themes/<t>.css` + `waybar/configs/<layout>/` → generated `style.css`, `config` |
| rofi | `rofi/themes/<t>.rasi` |
| mako | `mako/themes/<t>.conf` |
| gtk | `gtk-{3,4}.0/themes/<t>.css` → `gtk.css`, prefer-dark in `settings.ini` |
| zsh, fzf, nvim | `DOTFILES_THEME` env from `zsh/dotfiles-theme.env` |

## Add a theme
1. Add one file per app above, named `<theme>.<ext>`.
2. nvim: add a colourscheme block in `nvim/lua/plugins/theme.lua` guarded by `cond = theme == "<theme>"`.
3. zsh: fzf colours in `zsh/.zshrc` case block.
4. `install.sh`: add `--<theme>` flag.
5. `restow --<theme>`, preview cards regenerate on first switcher open.

Wallpapers live in `~/realm/builds/dotfiles/wallpapers/`, active one is the `current` symlink (hyprpaper + hyprlock use it).
