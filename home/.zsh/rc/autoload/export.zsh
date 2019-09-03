
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
  export "/usr/local/bin:/usr/bin:/bin:"
fi
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.android/sdk/platform-tools"
for v in `ls $HOME/.gem/ruby`; do
  export PATH="$PATH:$HOME/.gem/ruby/$v/bin"
done
export RUST_SRC_PATH=`echo $HOME/.rustup/toolchains/*/lib/rustlib/src/rust/src`
export GOPATH="$HOME/.go"
which nvim > /dev/null 2>&1 &&\
  export EDITOR=nvim

#function recExport(){
#  # シンボリックリンクであればリンク先も再帰的に
#  # 無限ループに気をつけて
#  if [ ! -d $1 ]; then return 1; fi
#  dir=`cd $1 > /dev/null; pwd`
#  if [ `echo $dir| awk -F/ '{print $NF}'` = ".git" ]; then return 0; fi
#  export PATH="$dir:${PATH}"
#  for i in `find "$dir" -maxdepth 1 -mindepth 1 -type d -o -type l`; do
#    if [ -L $i ]; then
#      recExport `readlink $i`
#    else
#      recExport $i
#    fi
#  done
#}
#
#if [ -d "${HOME}/bin" ]; then
#  recExport "${HOME}/bin"
#  echo "$PATH" > /tmp/cache-zsh-path
#fi
export PATH="${HOME}/bin/handyScript:${HOME}/bin:${PATH}"
