" use ctags to get function prototypes
if exists('g:loaded_my_ctags')
  finish
end
let g:loaded_my_ctags = 1

" transform the best ctags output we get to a usable prototype
function MakePrototype(num, str_val) abort
  " TODO: probably could do this with string indexing or something
  " remove the typename: from ctags output
  let l:interm = substitute(a:str_val, '\w\+:\(.*\)', '\1;', 'g')

  " add a space for every comma
  return substitute(l:interm, ',', ', ', 'g')

  unlet l:interm
endfunction

" get function signatures with ctags
function s:MakeFunctionSignatures(tag_paths) abort
  " variables to keep the cmd string small
  let l:ctags_arg = '--_xformat="%t %N%S" '
  let l:ctags_str = 'ctags -x --c++-types=f ' . l:ctags_arg . a:tag_paths

  " run the command
  let l:output = systemlist(l:ctags_str)
  " map the output to MakePrototype() and filter main()
  return filter(map(l:output, function('MakePrototype')), 'v:val !~ ".* main(.*).*"')

  unlet l:ctags_str l:ctags_arg l:output
endfunction

" set the desired options for the Signatures buffer
function s:InitBuffer() abort
  setlocal filetype=cpp
  setlocal noreadonly " in case the 'view' mode is used
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal textwidth=0

  setlocal nowrap
  setlocal nolist
  setlocal nospell
endfunction

" add string to a buffer
function s:AppendLines(to_append) abort
  " set modifiable just in case
  setlocal modifiable

  " just delete the whole buffer
  %delete

  " put text from variable in to text
  -1put =a:to_append

  " remove blank lines
  g/^$/d

  " move to the top
  normal! gg

  " freeze buffer
  setlocal nomodifiable
endfunction

" the Signatures window
function s:HandleWindow(output) abort
  let l:buf_name = 'function_prototypes'

  let l:prev_win_id = win_getid()

  let l:win_buff_nr = bufwinnr(l:buf_name)
  let l:buff_nr = bufnr(l:buf_name)

  if l:win_buff_nr == -1
    execute 'keepalt botright split ' . l:buf_name
    resize -10

    if l:buff_nr == -1
      call s:InitBuffer()
    endif

    call s:AppendLines(a:output)
  else
    if win_gotoid(win_getid(l:win_buff_nr)) == 1
      call s:AppendLines(a:output)

    endif
  endif

  call win_gotoid(l:prev_win_id)

  unlet l:buf_name l:buff_nr l:prev_win_id l:win_buff_nr
endfunction

" ether read in prototypes to a buffer or the file (at cursor)
function FunctionSignatures(...) abort
  if a:0 > 1
    let l:output = s:MakeFunctionSignatures(join(a:000[1:],  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  if a:1 == 'append'
    call append(line('.'), l:output)
  else
    call s:HandleWindow(l:output)
  endif

  unlet l:output
endfunction

" open a window with prototypes
command -complete=file -nargs=* Signatures
      \ :call FunctionSignatures('display', <f-args>)

" read prototypes in to file
command -complete=file -nargs=* SignaturesRead
      \ :call FunctionSignatures('append', <f-args>)

" add table of contents binding
augroup CtagsUtils
  autocmd!
  autocmd! FileType cpp,c :nnoremap <buffer> gO :call FunctionSignatures('display')<cr>
augroup END
" }}}

" vim: foldmethod=indent
