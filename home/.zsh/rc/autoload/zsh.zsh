bindkey -v

set no_beep
setopt magic_equal_subst
setopt auto_menu # 補完キー連打で順に補完候補を自動で補完
setopt list_packed
setopt correct
unsetopt sh_wordsplit
setopt auto_cd
function chpwd() { ls }

setopt auto_pushd
setopt pushd_ignore_dups
DIRSTACKSIZE=100
