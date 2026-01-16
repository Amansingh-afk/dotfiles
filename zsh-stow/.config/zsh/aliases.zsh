alias please='sudo $(fc -ln -1)'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo dnf update'

# zoxide
alias j='z'

# tmux Aliases
alias tm="tmux"
alias tmn="tmux new -s"
alias tma="tmux attach"
alias tmal="tmux attach -t"
alias tmks="tmux kill-session -t"
alias tml="tmux list-sessions"

#Open tmux with default setup
alias godmode="~/realm/builds/dotfiles/tmux-stow/.config/tmux/god-mode-tmux.sh"

# aws Aliases
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

alias lg=lazygit
