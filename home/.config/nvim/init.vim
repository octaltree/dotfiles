set termguicolors
set number
set notitle
set showmatch
set ambiwidth=double
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
set fileencodings=utf-8,euc-jp,cp932,iso-2022-jp

" ## indent ##########
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
augroup forbid_auto_comment_out
  autocmd!
  autocmd BufEnter * set formatoptions-=ro
augroup END

augroup py
  autocmd!
  autocmd FileType python setlocal ts=4 sw=4 sts=4 fdm=indent fdl=0 fdn=1 si et
  autocmd FileType python setlocal cinw=if,elif,else,for,while,try,except,finally,def,class
augroup END

" ## search ##########
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan

" ## ex ##########
runtime! macros/matchit.vim
runtime! rc/autoload/*
let s:thisdir = expand("<sfile>:p:h")
function! s:loadIfExist(relativepath)
  if filereadable(join([s:thisdir, a:relativepath], '/'))
    execute 'source' join([s:thisdir, a:relativepath], '/')
  endif
endfunction

let g:dein_dir=expand("<sfile>:p:h") . "/dein"
call s:loadIfExist("rc/plug.vim")
call s:loadIfExist("rc/plugafter.vim")
call s:loadIfExist("rc/" . hostname() . ".vim")
