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

inoremap jj <ESC>
vmap <c-[> <ESC>
nnoremap <ESC><ESC> :nohlsearch<CR>

nnoremap s <nop>
vnoremap s <nop>
nnoremap sm :<c-u>w<CR>:silent make -k -j4<CR>:redraw!<CR>
nnoremap sudo :<c-u>w !sudo tee % > /dev/null
