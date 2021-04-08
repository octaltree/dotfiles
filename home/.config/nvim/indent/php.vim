let s:keepcpo= &cpo
set cpo&vim

" /usr/share/nvim/runtime/indent/php.vim を使わない
let b:did_indent=1

let &cpo = s:keepcpo
unlet s:keepcpo
