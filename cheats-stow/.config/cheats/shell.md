# Shell (zsh)

`cheat` for sheets, `tldr <cmd>` for command examples, `Ctrl+r` for history search.

## Aliases
| Alias | Runs |
|---|---|
| `ls` / `ll` / `la` / `lt` | eza (icons) / long+git / all / tree 2 levels |
| `cat` | bat (plain, no pager) |
| `du` / `df` | dust / duf |
| `j <dir>` | zoxide jump (`zi` interactive) |
| `s` | pick tmux session (sesh) |
| `lg` / `ld` | lazygit / lazydocker |
| `y` | yazi, cd on quit |
| `please` | rerun last command with sudo |
| `update` | dnf update |
| `tm*` | tmux shortcuts, see `cheat tmux` |
| `ssm_*` | aws ssm sessions |

## Tools
| Tool | Use |
|---|---|
| `fd pattern [dir]` | find files. `-e ext`, `-H` hidden, `-x cmd` exec |
| `rg pattern [dir]` | grep. `-i`, `-t py`, `-l` files only, `-n` lines |
| `bat file` | cat with syntax, `-A` show all |
| `dust` / `duf` | disk usage tree / free space |
| `tldr cmd` | examples. `tldr --update` once |
| `jq . file.json` | JSON. `jq '.key[]'`, `-r` raw |
| `glow file.md` | render markdown |
| `delta` | git diff pager (configured in ~/.gitconfig) |
| `atuin` | history. `Ctrl+r` search, `atuin stats` |
| `direnv` | `.envrc` in project dir, `direnv allow`. Env loads on cd |
| `mise` | versions. `mise use node@22` (project), `mise use -g python@3.12` (global), `mise ls` |
| `zoxide` | `z dir`, `zi` pick, learns as you cd |
| `fzf` | `Ctrl+t` file, `Alt+c` cd, `**<Tab>` complete |

## Keys
Vi mode: `Esc` normal, `v` edit command in nvim, `/` search history. `Ctrl+t` fzf files, `Alt+c` fzf cd, `Ctrl+r` atuin.

## Files
`~/.zshenv` sets `ZDOTDIR=~/.config/zsh`. Config: `~/.config/zsh/{.zshrc,aliases,functions,plugins,keybindings,theme}.zsh`.
Secrets and machine-only stuff: `~/.zshrc.local` (mode 600, not in repo).
Reload: `exec zsh`. Profile: `zsh -ic 'zmodload zsh/zprof; zprof'`.
