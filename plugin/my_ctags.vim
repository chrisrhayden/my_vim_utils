if exists('g:loaded_my_ctags')
  finish
end
let g:loaded_my_ctags = 1

function s:MakeFunctionSignatures(tag_paths) abort
  let l:ctags_arg = '--_xformat="%t %N%S" '
  let l:ctags_str = 'ctags -x --c++-types=f ' . l:ctags_arg . a:tag_paths
  let l:ctags_output = systemlist(l:ctags_str)
  let l:ctags_output = filter(l:ctags_output, 'v:val !~ ".* main(.*)"')

  let l:output = systemlist('cut -d":" -f2-', l:ctags_output)
  map(l:output, {_, line -> line . ';'})

  return l:output
endfunction

function s:FunctionSignaturesDisplay(...) abort
  if a:0
    let l:output = s:MakeFunctionSignatures(join(a:000,  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  execute 'keepalt botright split ' . '[function prototypes]'
  execute 'resize -10'

  setlocal filetype=cpp
  call append(line('$') - 1, l:output)

  setlocal noreadonly " in case the "view" mode is used
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nomodifiable
  setlocal textwidth=0
endfunction

function s:FunctionSignaturesRead() abort
  if a:0
    let l:output = s:MakeFunctionSignatures(join(a:000,  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  call append(line('.'), l:output)
endfunction

command -complete=file -nargs=* Signatures :call <sid>FunctionSignaturesDisplay()
command -complete=file -nargs=* SignaturesRead :call <sid>FunctionSignaturesRead()
