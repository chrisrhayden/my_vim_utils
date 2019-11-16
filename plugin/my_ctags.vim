if exists('g:loaded_my_ctags')
  finish
end
let g:loaded_my_ctags = 1

function s:MakeFunctionSignatures(tag_paths) abort
  let l:ctags_str='ctags -x --c-types=f ' . a:tag_paths
  let l:ctags_output = system(l:ctags_str)

  let l:awk_arg_1 = 'if ($6 != "main()") '
  let l:awk_arg_2 = 'for(i=5; i <= NF; ++i) {printf $i; if (i != NF) printf FS; }'
  let l:awk_arg_3 = 'if ($6 != "main()") print ""'

  let l:awk_args = "'{" . l:awk_arg_2 . l:awk_arg_3 . "}'"

  let l:awk_str =  'awk ' . l:awk_args

  " system(cmd, stdin)
  let l:output = systemlist(l:awk_str, l:ctags_output)

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
