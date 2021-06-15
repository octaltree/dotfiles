setlocal colorcolumn=99
inoremap <c-f> ::

" インデント4スペース前提
function! RustFold(lnum) abort
  let line = getline(a:lnum)
  if line ==# ''
    return '='
  endif
  let matched = matchlist(line, '^\(\s*\).*')[1]
  let indent = len(matched) / 4
  let is_comment = match(line, '^\(\s*\)//') > -1
  if is_comment
    return indent + 1
  endif
  return !!indent
endfunction

setlocal foldmethod=expr foldexpr=RustFold(v:lnum)
