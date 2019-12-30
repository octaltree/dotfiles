let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python2'

command! -nargs=+ JE split | execute "terminal echo " . <q-args> . "| trans ja:en"
command! -nargs=+ EJ split | execute "terminal echo " . <q-args> . "| trans en:ja"
