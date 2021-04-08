if exists('b:did_ftplugin_cpp')
    finish
endif
let s:keepcpo= &cpo
set cpo&vim
let b:did_ftplugin_cpp=1

setlocal foldmethod=syntax

let &cpo = s:keepcpo
unlet s:keepcpo
