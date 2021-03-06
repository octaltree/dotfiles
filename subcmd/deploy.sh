#!/bin/bash

function copyDirSymRec(){
  # ディレクトリは作成 ファイルはシンボリックリンク を再帰的に
  # ただしhosts/はhosts/`hostname -s`/*についてhostと同じ階層にリンクを張る
  local originfiles=($(ls -ap $1| sed '/\//d'))
  local origindirs=($(ls -ap $1| sed '/\//!d'| awk -F/ '{print $1}'| sed '/^\.$/d' | sed '/^\.\.$/d'))
  for i in ${originfiles[@]}; do
    _failsafe _ newSym $1/$i $2/$i
  done
  for i in ${origindirs[@]}; do
    if [ $i = "hosts" ]; then
      h="$1/hosts/`hostname -s`"
      if ! [ -d "$h" ]; then continue; fi
      copyDirSymRec $h $2
    else
      _failsafe _ newDir $2/$i
      copyDirSymRec $1/$i $2/$i
    fi
  done
}

copyDirSymRec ${DOTFILESROOT}/home ${HOME}

#for i in `ls -v ${DOTFILESROOT}/src/postdeploy/`; do
#  . ${DOTFILESROOT}/src/postdeploy/$i
#done
