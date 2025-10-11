#!/bin/bash

SESSION="GOD-MODE"

# Kill existing session (optional but avoids conflicts)
tmux has-session -t $SESSION 2>/dev/null
if [ $? -eq 0 ]; then
  tmux kill-session -t $SESSION
fi

# Create new session with window "ecom"
tmux new-session -d -s $SESSION -n ecom
tmux split-window -h -t "$SESSION:ecom" 

# Create window "accounts" and split it
tmux new-window -t $SESSION -n accounts
tmux split-window -v -t "$SESSION:accounts"

# Create other windows
tmux new-window -t $SESSION -n ecom_queue
tmux new-window -t $SESSION -n ecom_cron

# Return to first window and first pane
tmux select-window -t "$SESSION:ecom"
tmux select-pane -t 0

# Attach to session
tmux attach-session -t $SESSION

