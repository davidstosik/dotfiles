tmux_session_name="0"
if [ -z "$TMUX" ] && tmux has-session -t "$tmux_session_name" >/dev/null 2>&1; then
  tmux attach -t "$tmux_session_name"
fi
