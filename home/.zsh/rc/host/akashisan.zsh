if [ -z "$TMUX" ]; then
  if [ `tmux list-sessions| sed '/attached/d'| wc -l` -ne 0 ]; then
    target=`tmux list-sessions| sed '/attached/d'| awk -F: '{print $1}'| head -n 1`
    tmux -2 attach-session -t $target
  else
    tmux -2
  fi
fi
