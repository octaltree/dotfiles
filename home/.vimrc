set number
set notitle
set showmatch
set ambiwidth=single
set autoread
set history=500
set colorcolumn=80
set wildmode=longest:full,full
set wildmenu
set virtualedit=block
set list
set listchars=eol:'
set background=dark
set clipboard=unnamed,unnamedplus
set shortmess+=I

au QuickfixCmdPost make,grep,grepadd,vimgrep cwindow

" ## file ##########
set fileformat=unix
set fileformats=unix,dos,mac
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932,iso-2022-jp,utf-16le

" ## indent ##########
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
augroup forbid_auto_comment_out
  autocmd!
  autocmd BufEnter * set formatoptions-=t
  autocmd BufEnter * set formatoptions-=c
  autocmd BufEnter * set formatoptions-=r
  autocmd BufEnter * set formatoptions-=o
augroup END

" ## search ##########
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

nnoremap ; q:a
nnoremap : ;
nnoremap q; :
nnoremap / q/a
nnoremap q/ /
nnoremap ? q?a
nnoremap q? ?
vnoremap ; q:a
vnoremap : ;

syntax on

set rtp+=~/.local/share/dein/repos/github.com/lifepillar/vim-solarized8
let g:solarized_termtrans=1
autocmd VimEnter * nested colorscheme solarized8

set rtp+=~/.config/nvim/rc/autoload/own.vim

let g:loaded_fzf=1
