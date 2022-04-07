alias opn=open

export PATH="/Users/octaltree/Library/handy:${PATH}"
export EDITOR=nvim


vi-pbpaste-a-x-selection(){
  LBUFFER=$LBUFFER$RBUFFER[1]
  RBUFFER=$(pbpaste)$RBUFFER[2,-1]
}
vi-pbpaste-b-x-selection(){
  RBUFFER=$(pbpaste)$RBUFFER
}
zle -N vi-pbpaste-a-x-selection
zle -N vi-pbpaste-b-x-selection
bindkey -M vicmd 'p' vi-pbpaste-a-x-selection
bindkey -M vicmd 'P' vi-pbpaste-b-x-selection


function vi-yank-pbcopy {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy
}
zle -N vi-yank-pbcopy
bindkey -M vicmd 'y' vi-yank-pbcopy

if [ "$TERM" = "alacritty" ]; then
  if [ `tmux list-sessions| sed '/attached/d'| wc -l` -ne 0 ]; then
    target=`tmux list-sessions| sed '/attached/d'| awk -F: '{print $1}'| head -n 1`
    tmux attach-session -t $target
  else
    tmux
  fi
fi
