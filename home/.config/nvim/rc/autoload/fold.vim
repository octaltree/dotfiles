set foldmethod=marker
set foldcolumn=0
set fillchars=vert:\|
set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return sub . ' ' . v:folddashes
endfunction

" vim: foldmethod=syntax
