source ~/.zsh/plugins/zplugin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

#zinit ice wait'' atinit'zpcompinit'; zinit load _local/incr
zinit ice lucid wait'' atinit'zpcompinit'; zinit load _local/auto_menu
zinit ice lucid wait'' atinit'zpcompinit'; zinit load zsh-users/zsh-autosuggestions
zinit ice lucid wait'!1'; zinit load _local/sandbox
zinit ice lucid wait'!1'; zinit load zsh-users/zsh-syntax-highlighting
zinit ice lucid wait'!1'; zinit load zsh-users/zsh-completions


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS="forward-word,vi-forward-blank-word-end"
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=""
bindkey -M viins '^f' forward-word
bindkey -M vicmd '^f' vi-forward-blank-word-end
