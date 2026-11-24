# Per-theme environment for TUI tools + prompt. DOTFILES_THEME comes from dotfiles-theme.env
# (written by theme-apply.sh). New shells pick up a theme switch; `exec zsh` for current ones.
autoload -U colors && colors
export CONDA_CHANGEPS1=false

_t="${DOTFILES_THEME:-gruvbox}"; _mode="dark"
case "$_t" in
  monochrome)
    export FZF_DEFAULT_OPTS='--color=fg:#e6e6e6,bg:-1,hl:#b3b3b3,fg+:#f0f0f0,bg+:#2e2e2e,hl+:#c2c2c2,info:#adadad,prompt:#b0b0b0,spinner:#9a9a9a,header:#a6a6a6'
    export BAT_THEME='ansi' ;;
  bsod)
    export FZF_DEFAULT_OPTS='--color=fg:#FFFFFF,bg:#0000AA,hl:#55FFFF,fg+:#FFFFFF,bg+:#AAAAAA,hl+:#55FFFF,info:#55FF55,prompt:#55FFFF,spinner:#AAAAAA,header:#AAAAAA'
    export BAT_THEME='ansi' ;;
  platinum)
    export FZF_DEFAULT_OPTS='--color=fg:#000000,bg:#DCDCDC,hl:#9999FF,fg+:#000000,bg+:#c0c0c0,hl+:#AAAAFF,info:#808080,prompt:#9999FF,spinner:#9b9b9b,header:#6e6e6e'
    export BAT_THEME='gruvbox-light'; _mode="light" ;;
  catppuccin-mocha)
    export FZF_DEFAULT_OPTS='--color=fg:#cdd6f4,bg:-1,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#89b4fa,prompt:#cba6f7,spinner:#f5e0dc,header:#94e2d5'
    export BAT_THEME='Catppuccin Mocha' ;;
  *)
    export FZF_DEFAULT_OPTS='--color=fg:#ebdbb2,bg:#282828,hl:#d79921,fg+:#fbf1c7,bg+:#3c3836,hl+:#d79921,info:#b8bb26,prompt:#fe8019,spinner:#fb4934,header:#83a598'
    export BAT_THEME='gruvbox-dark' ;;
esac
export GLAMOUR_STYLE="$_mode"                       # glow
export DELTA_FEATURES="+dotfiles-$_mode"            # delta, features in ~/.config/git/config; syntax follows BAT_THEME
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/$_t.yml"
[[ -f "$HOME/.config/starship/current.toml" ]] && export STARSHIP_CONFIG="$HOME/.config/starship/current.toml" \
  || export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
unset _t _mode

# --- Prompt ---
if [[ "$DOTFILES_THEME" = "bsod" ]]; then
  PROMPT='%F{cyan}C:\%~>%f '
  RPROMPT='%F{white}%T%f'
elif command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
fi
