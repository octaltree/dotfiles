let s:dein_dir = $HOME . "/.local/share/dein"
let s:dein_repo_dir = s:dein_dir . "/repos/github.com/Shougo/dein.vim"
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  let s:toml = expand("<sfile>:p:h") . "/dein.toml"
  let s:tomllazy = expand("<sfile>:p:h") . "/deinlazy.toml"
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:tomllazy, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

"if dein#check_install()
"  call dein#install()
"endif

filetype plugin indent on
syntax enable
