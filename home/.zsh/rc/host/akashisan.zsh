if [ -z "$TMUX" ]; then
  bs='prime'
  tmux has-session -t $bs || tmux new-session -d -s $bs
  cnt=$(tmux list-clients | wc -l)
  if [ $client_cnt -ge 1 ]; then
    name=$bs"-"$cnt
    tmux new-session -d -t $bs -s $name
    tmux -2 attach-session -t $name \; set-option destroy-unattached
  else
    tmux -2 attach-session -t $bs
  fi
fi
