if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufEnter,BufNewFile *aHR0cH* setfiletype ccs
  au! BufEnter,BufNewFile *.tag setfiletype javascript
  au! BufEnter,BufNewFile *.mq5 setfiletype cpp
  au! BufEnter,BufNewFile *.mqh setfiletype cpp
augroup END
