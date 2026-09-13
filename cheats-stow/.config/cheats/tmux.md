# tmux

Prefix is `Ctrl+a`. Press it, release, then the key.

## Sessions
| Key | Action |
|---|---|
| `s` in shell | pick session (sesh + fzf, includes zoxide dirs) |
| `prefix T` | same picker as popup |
| `prefix d` | detach |
| `prefix s` | switch session |
| `prefix $` | rename session |
| `prefix (` / `)` | previous / next session |
| `tmn name` / `tma` / `tml` / `tmks name` | new / attach / list / kill |
| `godmode` | ecom/accounts/queue/cron layout |

`sesh` sessions are defined in `~/.config/sesh/sesh.toml` (dotfiles, realm, home).

## Windows
| Key | Action |
|---|---|
| `prefix c` | new window |
| `prefix n` / `p` | next / previous |
| `prefix 1..9` | jump to window |
| `prefix ,` | rename |
| `prefix &` | kill |
| `prefix w` | list windows |
| `prefix f` | find window |

## Panes
| Key | Action |
|---|---|
| `prefix \|` | split vertical |
| `prefix -` | split horizontal |
| `prefix o` | next pane |
| `prefix ;` | last pane |
| `prefix z` | zoom pane |
| `prefix x` | kill pane |
| `prefix {` / `}` | move pane |
| `prefix Space` | cycle layouts |
| `prefix arrows` | move focus |
| mouse | click / drag / resize works |

## Copy mode
`prefix [` enter, `Space` start select, `Enter` copy, `prefix ]` paste, `q` quit. Scroll with mouse wheel.

## Other
| Key | Action |
|---|---|
| `prefix r` | reload config |
| `prefix H` | this sheet |
| `prefix :` | command prompt |
| `prefix Ctrl+s` / `Ctrl+r` | save / restore session (resurrect, auto every 15m) |
| `prefix I` | install plugins (tpm) |

Config: `~/.config/tmux/tmux.conf`.
