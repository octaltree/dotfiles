
#autoload -Uz promptinit
#promptinit

#PROMPT='[%n@%m %~]%# '    # default prompt
#zshプロンプトにモード表示####################################
#https://gist.github.com/otiai10/8034038
#http://nishikawasasaki.hatenablog.comuentry/20101227/1293459255 をコピペ改変
setopt prompt_subst #表示毎にPROMPTで設定されている文字列を評価する
autoload -U colors; colors

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    #PROMPT="[%n@%m/%{$fg[green]%}NOR%{$reset_color%}]%# "
    PROMPT="[%n%0(?||%{$fg[red]%})@%0(?||%{$reset_color%})%m/%{$fg[green]%}NOR%{$reset_color%}]%# "
    RPROMPT="%~/`branch-status-check` "
    ;;
  main|viins)
    #PROMPT="[%n@%m/%{$fg[green]%}NOR%{$reset_color%}]%# "
    PROMPT="[%n%0(?||%{$fg[red]%})@%0(?||%{$reset_color%})%m/%{$fg[cyan]%}INS%{$reset_color%}]%# "
    RPROMPT="%~/`branch-status-check` "
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

function branch-status-check {
  local prefix branchname suffix
  # .gitの中だから除外
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi
  branchname=`get-branch-name`
  # ブランチ名が無いので除外
  if [[ -z $branchname ]]; then
    return
  fi
  prefix=`get-branch-status` #色だけ返ってくる
  suffix='%{'${reset_color}'%}'
  echo ${prefix}${branchname}${suffix}
}

function get-branch-name {
  # gitディレクトリじゃない場合のエラーは捨てます
  echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

function get-branch-status {
  local res color
  output=`git status --short 2> /dev/null`
  if [ -z "$output" ]; then
    res=':' # status Clean
    color='%{'${fg[green]}'%}'
  elif [[ $output =~ "[\n]? M " ]]; then
    res='M:' # Modified
    color='%{'${fg[red]}'%}'
  elif [[ ! $output =~ "[\n]?\?\? " ]]; then
    res='A:' # Added to commit
    color='%{'${fg[yellow]}'%}'
  else
    res='?:' # Untracked
    color='%{'${fg[cyan]}'%}'
  fi
  # echo ${color}${res}'%{'${reset_color}'%}'
  echo ${color} # 色だけ返す
}



vi-paste-a-x-selection(){
  LBUFFER=$LBUFFER$RBUFFER[1]
  RBUFFER=$(xclip -sel clipboard -o)$RBUFFER[2,-1]
}
vi-paste-b-x-selection(){
  RBUFFER=$(xclip -sel clipboard -o)$RBUFFER
}
zle -N vi-paste-a-x-selection
zle -N vi-paste-b-x-selection
bindkey -M vicmd 'p' vi-paste-a-x-selection
bindkey -M vicmd 'P' vi-paste-b-x-selection
# vi-yank-x-selection(){
#   print -rn -- $BUFFER[$CURSOR+1,$MARK]| xclip -sel clipboard
#   deactivate-region
# }
# zle -N vi-yank-x-selection
# bindkey -M vicmd 'y' vi-yank-x-selection
