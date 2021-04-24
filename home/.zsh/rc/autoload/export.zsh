which nvim > /dev/null 2>&1 &&\
  export EDITOR=nvim

typeset -U PATH
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$HOME/bin/handyScript:$PATH"
export PATH="$HOME/bin:$PATH"

export RUST_BACKTRACE=1
which sccache > /dev/null 2>&1 &&\
  export RUSTC_WRAPPER=`which sccache`
export GOPATH="$HOME/.go"
export JAVA_HOME=/opt/android-studio/jre
