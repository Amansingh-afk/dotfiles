# git / lazygit

`lg` opens lazygit. `?` shows keys for the focused panel. Diffs use delta everywhere.

## lazygit
| Key | Action |
|---|---|
| `1..5` / `Tab` | panels: status, files, branches, commits, stash |
| `Space` / `a` | stage file / stage all |
| `Enter` on file | stage lines (`Space` line, `v` range) |
| `d` | discard changes |
| `c` / `C` | commit / commit in editor |
| `A` | amend last commit |
| `P` / `p` / `f` | push / pull / fetch |
| `n` | new branch |
| `Space` on branch | checkout |
| `M` / `r` | merge / rebase onto |
| `s` / `g` | stash / stash options |
| `z` / `Ctrl+z` | undo / redo |
| `e` / `o` | edit file / open |
| `/` | search |
| `+` | cycle screen size |
| `x` | menu for panel |
| `q` | quit |

## plain git
| Cmd | Use |
|---|---|
| `git switch -c name` | new branch |
| `git add -p` | stage hunks |
| `git commit --amend --no-edit` | fold into last commit |
| `git log --oneline --graph -20` | history |
| `git stash push -u -m tag` | stash incl. untracked |
| `git restore file` / `git restore --staged file` | undo working / unstage |
| `git rebase -i HEAD~3` | squash recent |
| `gh pr create -f` | PR from branch |

Config: `~/.gitconfig` (identity, delta), `~/.config/git/ignore` (global ignores).
