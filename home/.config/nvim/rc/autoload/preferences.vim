let g:vim_syn_embed='lP'

augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
    if 0 == match(a:dir, "suda://")
      return
    endif
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction  " }}}
augroup END  " }}}

command! CargoPlay w ! cargo play --stdin

command! -nargs=+ JAEN split | execute "terminal echo " . <q-args> . "| trans ja:en"
command! -nargs=+ ENJA split | execute "terminal echo " . <q-args> . "| trans en:ja"
