" :h map-table

nnoremap ; q:a
nnoremap : ;
nnoremap q; :
nnoremap / q/a
nnoremap q/ /
nnoremap ? q?a
nnoremap q? ?

vnoremap ; q:a
vnoremap : ;

nnoremap j gj
nnoremap k gk
nnoremap <c-k> zk
nnoremap <c-j> zj

inoremap <A-space> <ESC>
vmap <c-[> <ESC>
nnoremap <ESC><ESC> :nohlsearch<CR>

nnoremap s <nop>
vnoremap s <nop>
nnoremap sm :<c-u>w<CR>:silent make -k -j4<CR>:redraw!<CR>
nnoremap sudo :<c-u>w !sudo tee % > /dev/null
nnoremap sd @

nnoremap ) ])
nnoremap ( [(
nnoremap { [{
nnoremap } ]}
vnoremap ) ])
vnoremap ( [(
vnoremap { [{
vnoremap } ]}

nnoremap sc viw:s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
nnoremap s_ viw:s/\%V\([A-Z]\)/_\l\1/g<CR>
vnoremap sc :s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
vnoremap s_ :s/\%V\([A-Z]\)/_\l\1/g<CR>

let mapleader = "\<space>"
