let  s:dein_repo_dir = g:dein_dir . "/repos/github.com/Shougo/dein.vim"
if filereadable(s:dein_repo_dir . "/bin/installer.sh")
  execute 'set runtimepath^=' . s:dein_repo_dir

  if dein#load_state(g:dein_dir)
    call dein#begin(g:dein_dir)
    let s:toml = expand("<sfile>:p:h") . "/dein.toml"
    let s:tomllazy = expand("<sfile>:p:h") . "/deinlazy.toml"
    if !filereadable(s:toml)
      execute '! touch' s:toml
    endif
    if !filereadable(s:tomllazy)
      execute '! touch' s:tomllazy
    endif
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:tomllazy, {'lazy': 1})
    call dein#end()
    call dein#save_state()
  endif

  "if dein#check_install()
  "  call dein#install()
  "endif
endif
filetype plugin indent on
syntax enable
