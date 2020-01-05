let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python2'

if executable('trans')
  command! -nargs=+ JAEN split | execute "terminal echo " . <q-args> . "| trans ja:en"
  command! -nargs=+ ENJA split | execute "terminal echo " . <q-args> . "| trans en:ja"
endif

augroup ccs
  au!
  au BufEnter *aHR0cH* setlocal cursorline
  au BufEnter *aHR0cH* nnoremap <buffer>j j
  au BufEnter *aHR0cH* nnoremap <buffer>k k
augroup END

"set runtimepath+=~/workspace/*
