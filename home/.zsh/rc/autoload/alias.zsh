
alias ls='ls --color=auto'
alias ll='ls -al --color | less -R'
alias ssx='ssh -XC'
alias opn='xdg-open'
alias mv='mv -i'
alias d='docker'
alias nv='nvim'
alias ca='cargo'
alias enja='trans en:ja'
alias jaen='trans ja:en'
alias rmcolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias rmpac='paccache -k 2 -r && paccache -ruk0'

alias ad='git add'
alias br='git branch'
alias co='git checkout'
alias cl='git clone'
alias ci='git commit'
alias di='git diff'
alias fe='git fetch'
alias lg='git log --color --all --graph --decorate'
alias pu='git push'
alias re='git remote'
alias rp='git rev-parse'
alias rpr='git rev-parse --show-toplevel'
alias so='git show'
alias st='git status'
alias reb='git rebase'

function mkdcd(){
  mkdir "$1" && cd "$1"
}
