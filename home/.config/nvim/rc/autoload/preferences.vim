let g:completion = 'ddc'
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

command! -nargs=+ CargoOpen call CargoOpen(<f-args>)
function! CargoOpen(...)
  let xs = split(a:2, ":")
  let n = len(xs)
  let col = xs[n - 1]
  let row = xs[n - 2]
  let path = join(xs[0:n-3], ":")
  execute "e " . path
  call cursor(row, col)
endfunction
