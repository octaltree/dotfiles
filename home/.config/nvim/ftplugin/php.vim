if exists("b:did_ftplugin_php") | finish | endif
let s:keepcpo= &cpo
set cpo&vim
let b:did_ftplugin_php=1

setlocal noexpandtab

let &cpo = s:keepcpo
unlet s:keepcpo
