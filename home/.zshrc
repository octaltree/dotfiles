source ~/.zsh/rc/prompt.zsh
source ~/.zsh/rc/plug.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

if [ -d ~/.zsh/rc/autoload ] && [ -r ~/.zsh/rc/autoload ]; then
  for file in `ls -v ~/.zsh/rc/autoload`; do
    source ~/.zsh/rc/autoload/$file
  done
fi

if [ -f ~/.zsh/rc/localhost.zsh ]; then
  source ~/.zsh/rc/localhost.zsh
fi

if which zprof > /dev/null 2>&1; then
  zprof
fi
