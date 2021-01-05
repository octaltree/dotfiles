which nvim > /dev/null 2>&1 &&\
  export EDITOR=nvim

typeset -U PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/bin/handyScript:$PATH"
export PATH="$HOME/bin:$PATH"

export RUST_BACKTRACE=1
export GOPATH="$HOME/.go"
