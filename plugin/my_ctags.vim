if exists('g:loaded_my_ctags')
  finish
end
let g:loaded_my_ctags = 1

function s:MakeFunctionSignatures(tag_paths) abort
  let l:ctags_arg = '--_xformat="%t %N%S" '
  let l:ctags_str = 'ctags -x --c++-types=f ' . l:ctags_arg . a:tag_paths
  let l:ctags_output = system(l:ctags_str)

  " map the awk list to a dictionary
  return l:output
endfunction

function s:FunctionSignatures() abort
  if a:0
    let l:output = s:MakeFunctionSignatures(join(a:000,  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  call setloclist(0, map(l:output, { _, line -> {'text': line }}))

  lopen
endfunction

function s:FunctionSignaturesRead() abort
  if a:0
    let l:output = s:MakeFunctionSignatures(join(a:000,  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  call append(line('.'), l:output)
endfunction

command -complete=file -nargs=* Signatures :call <sid>FunctionSignatures()
command -complete=file -nargs=* SignaturesRead :call <sid>FunctionSignaturesRead()
