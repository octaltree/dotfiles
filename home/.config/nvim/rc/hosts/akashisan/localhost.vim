let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python2'

command! -nargs=+ W3ms execute 'silent ! tmux split-window -- w3m ' . <q-args>
command! -nargs=+ W3mv execute 'silent ! tmux split-window -h -- w3m ' . <q-args>

augroup ccs
  au!
  au BufEnter *aHR0cH* setlocal cursorline
  au BufEnter *aHR0cH* nnoremap <buffer>j j
  au BufEnter *aHR0cH* nnoremap <buffer>k k
  au BufEnter *aHR0cH* nnoremap <buffer><silent>sd 0wvEy:silent ! firefox `xclip -o`<cr>
augroup END

au BufRead,BufNewFile *.tag set filetype=javascript
au BufRead,BufNewFile *.mq5 set filetype=cpp
au BufRead,BufNewFile *.mqh set filetype=cpp
au BufRead,BufNewFile *.mq5 setlocal foldmethod=syntax
au BufRead,BufNewFile *.mqh setlocal foldmethod=syntax
au FileType yaml setlocal indentkeys-=0# indentkeys-=<:>

"set runtimepath+=~/workspace/*
