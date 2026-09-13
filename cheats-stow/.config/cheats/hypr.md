# Hyprland

`Super+/` opens the live keybind list (parsed from `keybinds.conf`, Enter runs it).
`Super+Shift+/` opens these cheat sheets. In a shell: `cheat`.

## Apps
| Key | Action |
|---|---|
| `Super+Return` | terminal (kitty) |
| `Super+Shift+Return` | floating terminal |
| `Super+`` ` | dropdown terminal (scratchpad, toggles) |
| `Super+E` | file manager (yazi) |
| `Super+C` | neovim |
| `Super+B` | browser (zen) |
| `Super+Space` | app launcher (rofi) |
| `Super+A` | audio mixer (wiremix) |
| `Super+N` / `Super+Shift+N` | network (nmtui) / bluetooth (bluetuith) |
| `Super+I` | btop |
| `Super+Shift+V` | clipboard history |
| `Super+.` | emoji picker |
| `Super+Alt+L` | lock |
| `Super+M` | exit Hyprland |

Scratchpads keep running while hidden. Press the key again to hide. Click elsewhere also hides.

## Windows
| Key | Action |
|---|---|
| `Super+Q` | close |
| `Super+F` / `Super+Shift+F` | fullscreen / maximize |
| `Super+V` | toggle floating |
| `Super+P` | pseudo-tile |
| `Super+T` | toggle split direction |
| `Super+h/j/k/l` | focus left/down/up/right |
| `Super+Shift+h/j/k/l` | move window |
| `Super+Ctrl+h/j/k/l` | resize |
| `Super+LMB drag` / `Super+RMB drag` | move / resize |

## Workspaces
| Key | Action |
|---|---|
| `Super+1..0` | go to workspace |
| `Super+Shift+1..0` | move window there |
| `Super+scroll` | next / prev workspace |
| `Super+S` / `Super+Shift+S` | toggle special workspace / send window there |

## Media
`XF86` audio, mic, play, brightness keys work. `Print` full screenshot, `Super+Print` region. Both save to `~/Pictures/Screenshots` and copy to clipboard.

## Theme
`Super+Shift+T` themes, `Super+Shift+B` bar layouts, `Super+Shift+W` wallpapers. See `cheat theme`.

## Files
`~/.config/hypr/`: `hyprland.conf` (startup, input, layout), `keybinds.conf`, `windowrules.conf`, `hypridle.conf` (idle: dim 4m, lock 5m, screen off 10m, suspend 30m), `hyprlock.conf`, `pyprland.toml` (scratchpads), `themes/`.
Reload: `hyprctl reload`. Check: `hyprctl configerrors`.
