set statusline=
set statusline+=%f
set statusline+=\ (%Y,%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding},%{&fileformat},bomb%{&bomb})
set statusline+=%=
set statusline+=\ %l,%c
set laststatus=2
