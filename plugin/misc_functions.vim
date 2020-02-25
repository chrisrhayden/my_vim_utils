" keep functions i dont want to mess or see in my rc with here
if exists('g:loaded_my_utils')
  finish
endif
let g:loaded_my_utils = 1

" Peserve {{{
function Preserve(command)
  " http://vimcasts.org/episodes/tidying-whitespace/
  " Preparation: save last search, and cursor position.
  " @/ = from the registry named /
  let l:save_hist=@/


  let l:save_line = line(".")
  let l:save_column = col(".")
  " Do the business:

  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=l:save_hist

  call cursor(save_line, save_column)
endfunction

" }}}

" transpose {{{
" from https://github.com/tpope/vim-rsi
function Transpose() abort
  let pos = getcmdpos()
  if getcmdtype() =~# '[?/]'
    return "\<C-T>"
  elseif pos > strlen(getcmdline())
    let pre = "\<Left>"
    let pos -= 1
  elseif pos <= 1
    let pre = "\<Right>"
    let pos += 1
  else
    let pre = ""
  endif
  return pre . "\<BS>\<Right>".matchstr(getcmdline()[0 : pos-2], '.$')
endfunction
" }}}
