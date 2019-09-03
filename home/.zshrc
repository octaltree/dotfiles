source ~/.zsh/rc/prompt.zsh
source ~/.zsh/rc/plug.zsh

if [ -d ~/.zsh/rc/autoload ] && [ -r ~/.zsh/rc/autoload ]; then
  for file in `ls -v ~/.zsh/rc/autoload`; do
    source ~/.zsh/rc/autoload/$file
  done
fi

source ~/.zsh/rc/`hostname -s`.zsh

if which zprof > /dev/null 2>&1; then
  zprof
fi
