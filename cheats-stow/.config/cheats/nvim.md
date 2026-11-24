# Neovim

Leader is `Space`. Press `Space` and wait: which-key shows the groups.

## Groups
| Keys | Action |
|---|---|
| `Space f f` / `f g` / `f b` / `f r` / `f h` / `f z` | find files / grep / buffers / recent / help / zoxide dir |
| `-` / `Space e e` / `e f` / `e c` | oil: parent dir / current dir / floating / project root. In oil: edit names, `dd` delete, `:w` apply, `-` up, `Enter` open, `Ctrl+v` vsplit, `g?` help |
| `Space b n` / `b p` / `b d` / `b x` / `b X` | buffer next / prev / delete / pick close / close others |
| `Space w s` / `w v` / `w c` / `w n` / `w =` | split / vsplit / close / next / equalize |
| `Space t t` / `t g` / `t n` / `t p` | terminal / lazygit / node / python |
| `Space c c` / `c F` / `c a` | Claude Code / format / code action |
| `Space t d` | todos file |
| `Space r n` / `Space D` / `Space F` | rename / type def / format |

## LSP (when attached)
| Keys | Action |
|---|---|
| `g d` / `g D` / `g i` / `g r` / `g R` | definition / declaration / implementation / references / references in Trouble |
| `K` | hover docs |
| `Ctrl+k` (insert mode) | signature help |
| `[d` / `]d` | prev / next diagnostic |
| `:Mason` | install language servers (lua, php, ts, python configured) |
| `:Lazy` | plugin manager (`U` update, `S` sync) |

## Moving
| Keys | Action |
|---|---|
| `Ctrl+h/j/k/l` | move between splits (also from terminal) |
| `Ctrl+d` / `Ctrl+u` | half page, cursor centered |
| `s` + two chars | flash jump |
| `J` / `K` in visual | move lines |
| `<` / `>` in visual | indent, keeps selection |
| `jk` | escape (better-escape) |

## Completion
`Tab` / `Shift+Tab` cycle, `Enter` accept, `Ctrl+Space` trigger, `Ctrl+e` close.

Config: `~/.config/nvim/` (`lua/config/keymaps.lua`, `lua/plugins/*.lua`). Theme follows `DOTFILES_THEME`.
