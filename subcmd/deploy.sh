#!/bin/bash

function copyDirSymRec(){
  # ディレクトリは作成 ファイルはシンボリックリンク を再帰的に
  # ただしhostというディレクトリがあったら中の `hostname -s`に該当するファイルに置き換える
  local originfiles=($(ls -ap $1| sed '/\//d'))
  local origindirs=($(ls -ap $1| sed '/\//!d'| awk -F/ '{print $1}'| sed '/^\.$/d' | sed '/^\.\.$/d'))
  for i in ${originfiles[@]}; do
    _failsafe _ newSym $1/$i $2/$i
  done
  for i in ${origindirs[@]}; do
    if [ $i = "host" ]; then
      if [ $(ls -a1 $1/host| grep `hostname -s`| wc -l) = "1" ]; then
        filename=`ls -a1 $1/host| grep $(hostname -s)`
        from="$1/host/$filename"
        to="$2/$filename"
        _failsafe _ newSym $from $to
      fi
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
