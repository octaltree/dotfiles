setopt auto_menu # 補完キー連打で順に補完候補を自動で補完

function select-history(){
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$BUFFER")
  CURSOR=$#BUFFER
}

zle -N select-history
bindkey -M vicmd 'H' select-history
