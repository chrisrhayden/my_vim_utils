" use ctags to get function prototypes
if exists('g:loaded_my_ctag_cmds')
  finish
end
let g:loaded_my_ctag_cmds = 1

" open a window with prototypes
command -complete=file -nargs=* Signatures
      \ :call ctag_functions#FunctionSignatures('display', <f-args>)

" read prototypes in to the current buffer
command -complete=file -nargs=* SignaturesRead
      \ :call ctag_functions#FunctionSignatures('read_into', <f-args>)
" }}}

" vim: foldmethod=indent
