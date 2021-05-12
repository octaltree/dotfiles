if exists("b:did_ftplugin_css") | finish | endif
let s:keepcpo= &cpo
set cpo&vim
let b:did_ftplugin_css=1

setlocal iskeyword-=-

let &cpo = s:keepcpo
unlet s:keepcpo
