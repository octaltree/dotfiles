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
nnoremap sd @

nnoremap sc viw:s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
nnoremap s_ viw:s/\%V\([A-Z]\)/_\l\1/g<CR>
xnoremap sc :s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
xnoremap s_ :s/\%V\([A-Z]\)/_\l\1/g<CR>

let mapleader = "\<space>"

function! g:LC_maps() abort
  nnoremap <silent><buffer><c-]> :lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent><buffer>gd    :lua vim.lsp.buf.definition()<CR>
  nnoremap <silent><buffer>K     :lua vim.lsp.buf.hover()<CR>
  nnoremap <silent><buffer>gD    :lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent><buffer><c-k> :lua vim.lsp.buf.signature_help()<CR>
  nnoremap <silent><buffer>1gD   :lua vim.lsp.buf.type_definition()<CR>
  nnoremap <silent><buffer>gr    :lua vim.lsp.buf.references()<CR>
  nnoremap <silent><buffer>g0    :lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent><buffer>gW    :lua vim.lsp.buf.workspace_symbol()<CR>
  nnoremap <silent><buffer>ss    :lua vim.lsp.buf.formatting()<cr>
  nnoremap <silent>ga    <cmd>lua vim.lsp.buf.code_action()<CR>
  setlocal signcolumn=yes
endfunction
