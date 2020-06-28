set termguicolors
set number
set notitle
set showmatch
set ambiwidth=single
set autoread
set history=10000
set colorcolumn=80
set wildmode=longest:full,full
set wildmenu
set virtualedit=block
set list
set listchars=eol:'
set background=dark
set clipboard=unnamed,unnamedplus
set pumblend=30
set winblend=30

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

" ## ex ##########
runtime! rc/autoload/*
let s:thisdir = expand("<sfile>:p:h")
let g:dein_dir=s:thisdir . "/dein"

runtime rc/plug.vim
