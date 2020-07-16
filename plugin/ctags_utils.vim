" use ctags to get function prototypes
if exists('g:loaded_my_ctag_cmds')
  finish
end
let g:loaded_my_ctag_cmds = 1

" open a window with prototypes
command -complete=file -nargs=* Signatures
      \ :call ctag_functions#FunctionSignatures('display', <f-args>)

" read prototypes in to file
command -complete=file -nargs=* SignaturesRead
      \ :call ctag_functions#FunctionSignatures('append', <f-args>)

" add table of contents binding
augroup CtagsUtils
  autocmd!
  autocmd! FileType cpp,c :nnoremap <buffer> gO :call ctag_functions#FunctionSignatures('display')<cr>
augroup END
" }}}

" vim: foldmethod=indent
