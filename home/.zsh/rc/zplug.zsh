sourceIfReadable ~/.zsh/plugins/zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"

if ! zplug check --verbose; then zplug install; fi
zplug load
