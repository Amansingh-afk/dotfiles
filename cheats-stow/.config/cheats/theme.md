# Themes, wallpapers

Themes: `gruvbox` (default), `monochrome`.

## Switch
| How | What |
|---|---|
| `Super+Alt+T` | theme cards (rofi) |
| `Super+Alt+W` | wallpaper cards (plus Random) |
| `./install.sh restow --monochrome` | from terminal, also re-links everything |

One bar layout (outline), coloured by the theme.

## What a theme touches
| App | File |
|---|---|
| kitty | `kitty/themes/<t>.conf` → `current.conf` (running kitties reload) |
| hyprland | `hypr/themes/<t>.conf` (borders, blur, animations) |
| waybar | `waybar/themes/<t>.css` → `current.css` (imported by `style.css`), `config.in` → generated `config` |
| rofi | `rofi/themes/<t>.rasi` |
| mako | `mako/themes/<t>.conf` |
| gtk | `gtk-{3,4}.0/themes/<t>.css` → `gtk.css` |
| zsh, fzf, nvim | `DOTFILES_THEME` env from `zsh/dotfiles-theme.env` |
| bat, delta, glow, lazygit | env in `zsh/theme.zsh`: `BAT_THEME`, `DELTA_FEATURES`, `GLAMOUR_STYLE`, `LG_CONFIG_FILE` → `lazygit/themes/<t>.yml` |
| starship | `starship/starship.toml` palettes → generated `current.toml` |
| yazi | `yazi/themes/<t>.toml` → `theme.toml` (flavors vendored in `yazi/flavors/`) |
| btop | `btop/btop.conf.in` → generated `btop.conf` |
| cava | terminal colours, nothing to do |

## Add a theme
1. Add one file per app above, named `<theme>.<ext>` (yazi, lazygit, starship palette, btop map in `theme-apply.sh`).
2. nvim: add a colourscheme block in `nvim/lua/plugins/theme.lua` guarded by `cond = theme == "<theme>"`.
3. zsh: fzf + bat colours in `zsh/theme.zsh` case block.
4. `install.sh`: add `--<theme>` flag.
5. `restow --<theme>`, preview cards regenerate on first switcher open.

Shells opened before a switch keep the old env: `exec zsh`.

Wallpapers live in `~/realm/builds/dotfiles/wallpapers/`, active one is the `current` symlink (hyprpaper + hyprlock use it).
