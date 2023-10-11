let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python'
let g:previm_open_cmd = '/Applications/Firefox.app/Contents/MacOS/firefox'

au Filetype ruby setlocal foldnestmax=0

function! SetStatusLine()
  if &filetype == "w3m"
    return '%2*' . '%=%*'
  endif
  let e = has('multi_byte') && &fileencoding!=''? &fileencoding: &encoding
  let t = '(%Y,' . e . ',%{&fileformat},bomb%{&bomb})'
  return '%f ' . t . '%= %l,%c'
endfunction

hi User2 gui=none guibg=none guifg=none

set statusline=%!SetStatusLine()
