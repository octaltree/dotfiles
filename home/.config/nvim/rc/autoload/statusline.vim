set statusline=
set statusline+=%f
set statusline+=\ [%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding},%{&fileformat}]
set statusline+=%=
set statusline+=\ %l,%c
set laststatus=2
