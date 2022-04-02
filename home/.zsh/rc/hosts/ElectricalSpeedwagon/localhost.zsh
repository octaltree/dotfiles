
(){
  if ! [ -z "$TMUX" ] || [ "$TERM" != "alacritty" ]; then
    return
  fi
  if [ `tmux list-sessions| sed '/attached/d'| wc -l` -ne 0 ]; then
    target=`tmux list-sessions| sed '/attached/d'| awk -F: '{print $1}'| head -n 1`
    tmux attach-session -t $target
  else
    tmux
  fi
}

alias opn=open

export PATH="/Users/octaltree/Library/handy:${PATH}"
export EDITOR=nvim
