
#history###############################################
#漢のzshより
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

#historyをいい感じに#############################
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end hisotry-search-end
bindkey -a "k" history-beginning-search-backward-end
bindkey -a "^N" hisotry-beginning-search-forward-end
