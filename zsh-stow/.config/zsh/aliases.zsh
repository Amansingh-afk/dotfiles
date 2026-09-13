# Aliases. `cheat shell` lists these with explanations.

# Modern replacements (installed by ./install.sh deps)
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias cat='bat --style=plain --paging=never'
alias du='dust'
alias df='duf'
alias grep='grep --color=auto'
alias help='cheat'

alias ..='cd ..'
alias ...='cd ../..'
alias please='sudo $(fc -ln -1)'
alias update='sudo dnf update'

# zoxide
alias j='z'

# tmux / sessions
alias tm="tmux"
alias tmn="tmux new -s"
alias tma="tmux attach"
alias tmal="tmux attach -t"
alias tmks="tmux kill-session -t"
alias tml="tmux list-sessions"
alias s='sesh connect "$(sesh list -i | fzf --prompt="session > ")"'
alias godmode="~/.config/tmux/god-mode-tmux.sh"

# TUIs
alias lg='lazygit'
alias ld='lazydocker'

# aws
alias ssm_frontends_1="aws ssm start-session --region ap-south-1 --target i-0448dfe585d06f53c"
alias ssm_redis_1="aws ssm start-session --region ap-south-1 --target i-06e9850259d4a087d"
alias ssm_accounts_1="aws ssm start-session --region ap-south-1 --target i-0a62574d745b9ebd0"
alias ssm_rabbitmq_1="aws ssm start-session --region ap-south-1 --target i-0a797c722439d1724"
alias ssm_dbrepl_1="aws ssm start-session --region ap-south-1 --target i-0c8b0b3745514bdb2"
alias ssm_ecom3_1="aws ssm start-session --region ap-south-1 --target i-0e16a8c068440864c"
alias ssm_ecom3db_1="aws ssm start-session --region ap-south-1 --target i-0e823dae83bd8b49e"
alias ssm_jenkins="aws ssm start-session --region ap-south-1 --target i-06cefb7717be06346"
alias ssm_ecom3_cron="aws ssm start-session --region ap-south-1 --target i-07b7c60401b16bab5"
alias ssm_ecom3_queue="aws ssm start-session --region ap-south-1 --target i-0805a44003b33d616"
