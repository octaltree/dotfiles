function removePath(){
  export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`;
}

function currentEnv(){
  for p in `echo "$CURRENT_ADDED_PATH"| sed 's/:/ /g'`; do
    removePath "$p"
  done
  if ls | grep node_modules >/dev/null; then
    local p="`pwd`/node_modules/.bin"
    export PATH="$p:$PATH"
    export CURRENT_ADDED_PATH="$p:$CURRENT_ADDED_PATH"
  fi
  if [[ -n $VIRTUAL_ENV ]]; then # venv内
    # current pathがvenv外ならdeactivate
    local root=`dirname $VIRTUAL_ENV`
    if ! [[ `pwd` =~ "^$root" ]]; then
      deactivate
    fi
  fi
  if ls | sed '/^ve$/!d' | grep ve >/dev/null; then
    source "`pwd`/ve/bin/activate"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd currentEnv
currentEnv
