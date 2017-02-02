
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
  export "/usr/local/bin:/usr/bin:/bin:"
fi

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
