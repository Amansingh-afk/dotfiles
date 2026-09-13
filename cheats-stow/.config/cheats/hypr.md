# Hyprland

`Super+/` opens the live keybind list (parsed from `keybinds.conf`, Enter runs it).
`Super+Shift+/` opens these cheat sheets. In a shell: `cheat`.

## The rule
| Modifier | Means |
|---|---|
| `Super+key` | launch or toggle an app |
| `Super+Shift+key` | same app, alternate form |
| `Super+Q F V X O G Tab hjkl` | window verbs |
| `Super+1..0 [ ] Esc` | workspaces |
| `Super+Alt+key` | system and appearance, rare |
| `Print` family | screenshots |

## Apps
| Key | Action | `+Shift` |
|---|---|---|
| `Super+Return` | terminal | floating terminal |
| `Super+`` ` | dropdown terminal (toggle) | |
| `Super+Space` | app launcher | |
| `Super+E` | files (yazi) | floating yazi |
| `Super+C` | code (neovim) | |
| `Super+B` | browser | private window |
| `Super+A` | audio mixer (wiremix) | |
| `Super+N` | network (nmtui) | bluetooth (bluetuith) |
| `Super+I` | system info (btop) | |
| `Super+.` | emoji picker | |

Scratchpads (dropdown, mixer, network, bluetooth, btop) keep running while hidden. Same key hides. Clicking elsewhere hides.

## Windows
| Key | Action |
|---|---|
| `Super+Q` | close |
| `Super+F` / `Super+Shift+F` | fullscreen / maximize |
| `Super+V` | toggle floating |
| `Super+X` | center floating window |
| `Super+O` | pin (floating, every workspace) |
| `Super+G` / `Super+Shift+G` | group windows as tabs / leave group |
| `Super+Ctrl+Tab` | next tab in group |
| `Super+Tab` / `Super+Shift+Tab` | next / previous window |
| `Super+h/j/k/l` (or arrows) | focus |
| `Super+Shift+h/j/k/l` | move window |
| `Super+Ctrl+h/j/k/l` | resize (40px) |
| `Super+LMB` / `Super+RMB` drag | move / resize |
| `Super+S` / `Super+Shift+S` | stash workspace toggle / send window to stash |

## Workspaces
| Key | Action |
|---|---|
| `Super+1..0` | go to workspace |
| `Super+Shift+1..0` | move window there |
| `Super+[` / `Super+]` | previous / next workspace |
| `Super+Shift+[` / `]` | move window to previous / next |
| `Super+Esc` | last used workspace |
| `Super+scroll` | previous / next |

## System and appearance (Super+Alt)
| Key | Action |
|---|---|
| `Super+Alt+L` | lock |
| `Super+Alt+M` | power menu: logout, sleep, reboot, power off |
| `Super+Alt+R` | reload Hyprland config |
| `Super+Alt+T` / `B` / `W` | theme / bar layout / wallpaper switcher |
| `Super+Alt+V` | clipboard history |
| `Super+Alt+D` | dismiss all notifications |
| `Super+Alt+S` | toggle split direction |

## Media and screenshots
Volume, mute, mic, play, next, brightness keys work, also on the lock screen.
`Print` region, `Shift+Print` full screen, `Ctrl+Print` active window. Saved to `~/Pictures/Screenshots` and copied to clipboard.

## Files
`~/.config/hypr/`: `hyprland.conf` (startup, input, layout), `keybinds.conf`, `windowrules.conf`, `hypridle.conf` (idle: dim 4m, lock 5m, screen off 10m, suspend 30m), `hyprlock.conf`, `pyprland.toml` (scratchpads), `themes/`, `env.conf` (generated PATH).
Reload: `Super+Alt+R` or `hyprctl reload`. Check: `hyprctl configerrors`.
