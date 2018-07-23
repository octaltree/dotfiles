
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
  export "/usr/local/bin:/usr/bin:/bin:"
fi
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.gem/ruby/`ls $HOME/.gem/ruby| head -n 1`/bin"
export RUST_SRC_PATH=`echo $HOME/.rustup/toolchains/*/lib/rustlib/src/rust/src`

function recExport(){
  # シンボリックリンクであればリンク先も再帰的に
  # 無限ループに気をつけて
  if [ ! -d $1 ]; then return 1; fi
  dir=`cd $1 > /dev/null; pwd`
  if [ `echo $dir| awk -F/ '{print $NF}'` = ".git" ]; then return 0; fi
  export PATH="$dir:${PATH}"
  for i in `find "$dir" -maxdepth 1 -mindepth 1 -type d -o -type l`; do
    if [ -L $i ]; then
      recExport `readlink $i`
    else
      recExport $i
    fi
  done
}

if [ -d "${HOME}/bin" ]; then
  recExport "${HOME}/bin"
fi

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
  if ls | sed '/^ve$/!d' | grep ve >/dev/null; then
    local p="`pwd`/ve/bin"
    export PATH="$p:$PATH"
    export CURRENT_ADDED_PATH="$p:$CURRENT_ADDED_PATH"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd currentEnv
currentEnv
