source ~/.zsh/plugins/zplugin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin ice wait'' atinit'zpcompinit'; zplugin load _local/incr
zplugin ice wait'' atinit'zpcompinit'; zplugin load _local/auto_menu
zplugin ice wait'!0'; zplugin load _local/sandbox
zplugin ice wait'!0'; zplugin load zsh-users/zsh-syntax-highlighting
zplugin ice wait'!0'; zplugin load zsh-users/zsh-completions
