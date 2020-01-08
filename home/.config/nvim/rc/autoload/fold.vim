set foldmethod=syntax
set foldnestmax=1
set foldcolumn=0

" 折りたたみの見た目
set fillchars=vert:\|
set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return sub . ' ' . v:folddashes
endfunction

au FileType python,haskell,vim,makefile,shell setlocal foldmethod=indent

" markerつけたらファイル末尾で設定する
