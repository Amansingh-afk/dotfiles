# yazi (file manager)

Open: `Super+E`, or `y` in a shell (cd's to the dir you quit in). Images/PDF preview in kitty.

## Move
| Key | Action |
|---|---|
| `h` / `l` | parent / enter or open |
| `j` / `k` | down / up, `J` / `K` by 5 |
| `gg` / `G` | top / bottom |
| `Enter` | open with default app (see `cheat apps`) |
| `o` / `O` | open with... / interactive |
| `z` | jump with zoxide |
| `Z` | jump with fzf |
| `/` / `?` | search forward / backward (`n` `N` next) |
| `.` | toggle hidden files |
| `~` | help, all keys |

## Files
| Key | Action |
|---|---|
| `Space` / `v` / `V` | select / visual mode / unset visual |
| `Ctrl+a` / `Ctrl+r` | select all / invert |
| `y` / `x` / `p` / `P` | copy / cut / paste / paste overwrite |
| `Y` / `X` | cancel copy / cut |
| `d` / `D` | trash / delete permanently |
| `a` | create (end with `/` for dir) |
| `r` | rename |
| `c c` / `c d` / `c f` | copy path / dir / filename |
| `;` / `:` | run shell command (blocking) |
| `s` / `S` | search by name (fd) / content (rg) |
| `,` then key | sort (a name, m modified, s size, e ext, n natural) |

## Tabs
`t` new tab, `1..9` switch, `[` / `]` prev / next, `{` / `}` swap, `Ctrl+c` close.

## Quit
`q` quit (and cd if opened via `y`), `Q` quit without cd.

## As file picker
Browser upload dialogs open yazi in a floating window: `Enter` picks a file, `Space` selects several then `Enter`, `q` in a dir picks that dir (for "choose folder").

Config: `~/.config/yazi/` (defaults). `yazi --debug` for preview issues.
