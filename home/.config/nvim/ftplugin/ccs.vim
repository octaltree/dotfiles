if exists("b:did_ftplugin_ccs") | finish | endif

let s:keepcpo= &cpo
set cpo&vim
let b:did_ftplugin_ccs=1

setlocal cursorline
nnoremap <buffer>j j
nnoremap <buffer>k k
nnoremap <buffer><silent>sd 0wvEy:silent ! firefox `xclip -o`<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
