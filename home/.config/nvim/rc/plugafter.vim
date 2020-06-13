if executable('clangd')
  lua require'nvim_lsp'.clangd.setup{}
  au FileType c set omnifunc=v:lua.vim.lsp.omnifunc
  au FileType cpp set omnifunc=v:lua.vim.lsp.omnifunc
endif
if executable('pyls')
  lua require'nvim_lsp'.pyls.setup{}
  au FileType python set omnifunc=v:lua.vim.lsp.omnifunc
endif
"if executable('typescript-language-server')
"  lua require'nvim_lsp'.tsserver.setup{}
"  au FileType javascript set omnifunc=v:lua.vim.lsp.omnifunc
"  au FileType javascriptreact set omnifunc=v:lua.vim.lsp.omnifunc
"  au FileType javascript.jsx set omnifunc=v:lua.vim.lsp.omnifunc
"  au FileType typescript set omnifunc=v:lua.vim.lsp.omnifunc
"  au FileType typescriptreact set omnifunc=v:lua.vim.lsp.omnifunc
"  au FileType typescript.jsx set omnifunc=v:lua.vim.lsp.omnifunc
"endif
if executable('intelephense')
  lua require'nvim_lsp'.intelephense.setup{}
  au FileType php set omnifunc=v:lua.vim.lsp.omnifunc
endif
