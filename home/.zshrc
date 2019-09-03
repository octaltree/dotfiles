function sourceIfReadable(){
  [ -r "$1" ] && source "$1"
}

sourceIfReadable ~/.zsh/rc/plug.zsh

if [ -d ~/.zsh/rc/autoload ] && [ -r ~/.zsh/rc/autoload ]; then
  for file in `ls -v ~/.zsh/rc/autoload`; do
    sourceIfReadable ~/.zsh/rc/autoload/$file
  done
fi

sourceIfReadable ~/.zsh/rc/`hostname -s`.zsh

if which zprof > /dev/null 2>&1; then
  zprof
fi
