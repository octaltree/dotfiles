
#history###############################################
#漢のzshより
HISTFILE=~/.zsh_history
HISTSIZE=99999999999999999
SAVEHIST=99999999999999999
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

#historyをいい感じに#############################
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -a "k" history-beginning-search-backward-end
bindkey -a "^N" history-beginning-search-forward-end
