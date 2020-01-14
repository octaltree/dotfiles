source ~/.zsh/plugins/zplugin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

#zplugin ice wait'' atinit'zpcompinit'; zplugin load _local/incr
zplugin ice wait'' atinit'zpcompinit'; zplugin load _local/auto_menu
zplugin ice wait'' atinit'zpcompinit'; zplugin load zsh-users/zsh-autosuggestions
zplugin ice wait'!0'; zplugin load _local/sandbox
zplugin ice wait'!0'; zplugin load zsh-users/zsh-syntax-highlighting
zplugin ice wait'!0'; zplugin load zsh-users/zsh-completions


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS="forward-word,vi-forward-blank-word-end"
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=""
bindkey -M viins '^f' forward-word
bindkey -M vicmd '^f' vi-forward-blank-word-end
