set foldmethod=indent
set foldnestmax=2
set foldcolumn=0

au WinEnter * if nvim_win_get_config(0)['relative'] != '' | setlocal foldnestmax=0 | endif

" 折りたたみの見た目
set fillchars=vert:\|
set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return sub . ' ' . v:folddashes
endfunction

" markerつけたらファイル末尾で設定する
