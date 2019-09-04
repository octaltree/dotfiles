bindkey -v

set no_beep
setopt magic_equal_subst
setopt list_packed
setopt correct
setopt noclobber
unsetopt sh_wordsplit
setopt auto_cd
function chpwd() { ls }

setopt auto_pushd
setopt pushd_ignore_dups
DIRSTACKSIZE=100
