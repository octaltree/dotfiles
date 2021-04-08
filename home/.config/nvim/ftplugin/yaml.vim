if exists('b:did_ftplugin_yaml')
    finish
endif
let s:keepcpo= &cpo
set cpo&vim
let b:did_ftplugin_yaml=1

setlocal indentkeys-=0# indentkeys-=<:>

let &cpo = s:keepcpo
unlet s:keepcpo
