set termguicolors
set number
set notitle
set showmatch
set ambiwidth=single
set autoread
set history=100
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

" ## status ##########
set laststatus=0
set rulerformat=%l,%c%=
set statusline=
set statusline+=%f
set statusline+=\ (%Y,%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding},%{&fileformat},bomb%{&bomb})
set statusline+=%=
set statusline+=\ %l,%c

" ## ex ##########
runtime! rc/autoload/*

runtime rc/plug.vim
runtime rc/plugafter.vim
runtime rc/localhost.vim
