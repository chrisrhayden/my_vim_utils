if exists('g:loaded_my_ctag_functions')
  finish
end
let g:loaded_my_ctag_functions = 1

" a wrapper function to call in map
" NOTE: the main and other functions could be filtered here for speed
function MakePrototype(num, str_val) abort
  " remove the trailing space ` ` and maybe `{` and add a `;`
  return substitute(a:str_val, ' \?{\?$', ';', 'g')
endfunction

" get function signatures with ctags
function s:MakeFunctionSignatures(tag_paths) abort
  let l:langs_to_use = ['c', 'cpp']
  let l:lang_indx = index(l:langs_to_use, &filetype)

  if l:lang_indx == 0
    let l:lang_opts = '--kinds-C=f '
  elseif l:lang_indx == 1
    let l:lang_opts = '--kinds-C++=f '
  else
    echomsg 'not a c/c++ file'
    return
  endif

  " --_xformat is not documented in the man page
  " https://docs.ctags.io/en/latest/news.html#customizing-xref-output
  " see `ctags --list-fields` for format options
  let l:ctags_str = 'ctags -x --_xformat="%C" ' . l:lang_opts . a:tag_paths

  " run the command
  let l:output = systemlist(l:ctags_str)

  " map the output to MakePrototype() and filter main()
  " map() needs a `Funcref` so we use the __function()__ function
  return filter(map(l:output, function('MakePrototype')), 'v:val !~ ".* main(.*).*"')
endfunction

" set the desired options for the Signatures buffer
function s:InitBuffer() abort
  setlocal filetype=cpp
  " in case the 'view' mode is used so we can add to the buffer
  setlocal noreadonly
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
function s:AddLines(to_append) abort
  " set modifiable in case we are reusing a buffer
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

    call s:AddLines(a:output)
  else
    if win_gotoid(win_getid(l:win_buff_nr)) == 1
      call s:AddLines(a:output)

    endif
  endif

  call win_gotoid(l:prev_win_id)
endfunction

" ether read in prototypes to a buffer or the file (at cursor)
function ctag_functions#FunctionSignatures(...) abort
  if a:0 > 1
    let l:output = s:MakeFunctionSignatures(join(a:000[1:],  ' '))
  else
    let l:output = s:MakeFunctionSignatures(expand('%'))
  endif

  if a:1 == 'read_into'
    " read into the current buffer at the cursor
    call append(line('.'), l:output)
  else
    call s:HandleWindow(l:output)
  endif
endfunction
