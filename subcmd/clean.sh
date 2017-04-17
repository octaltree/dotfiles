#!/bin/bash

function rmRec(){
  local originfiles=($(ls -ap $1| sed '/\//d'))
  local origindirs=($(ls -ap $1| sed '/\//!d'| awk -F/ '{print $1}'| sed '/^\.$/d' | sed '/^\.\.$/d'))
  local i=0
  for i in ${originfiles[@]}; do
    [ -e $2/$i ] && _failsafe _ rm $2/$i
  done
  for i in ${origindirs[@]}; do
    if [ $i = "host" ]; then
      if [ $(ls -a1 $1/host| grep `hostname -s`| wc -l) = "1" ]; then
        local filename=`ls -a1 $1/host| grep $(hostname -s)`
        local to="$2/$filename"
        [ -e $to ] && _failsafe _ rm $to
      fi
    else
      rmRec $1/$i $2/$i
      [ -e $2/$i ] &&\
        [ `ls -A "$2/$i"| wc -l` -eq 0 ] &&\
        _failsafe _ rmdir $2/$i
    fi
  done
}

function main(){
  rmRec ${DOTFILESROOT}/home ${HOME}
  if [ `ls -A $HOME| grep $BAKPREF| wc -l` -eq 0 ]; then return 0; fi
  local bak=$2
  if [ "$bak" = "" ]; then
    bak="$HOME/`ls -av $HOME| grep ${BAKPREF}| head -n 1`"
  fi
  restoreRec $bak ""
}

main $@
