lua require('plugafter')

augroup update-markdown-syntax
  autocmd!
  autocmd FileType markdown syntax match markdownError '\w\@<=\w\@='
augroup END
