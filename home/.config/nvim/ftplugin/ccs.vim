if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin=1

setlocal cursorline
nnoremap <buffer>j j
nnoremap <buffer>k k
nnoremap <buffer><silent>sd 0wvEy:silent ! firefox `xclip -o`<cr>
