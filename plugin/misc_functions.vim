if exists('g:loaded_my_utils')
  finish
endif
let g:loaded_my_utils = 1


" Preserve {{{
function! Preserve(command)
  " http://vimcasts.org/episodes/tidying-whitespace/
  " Preparation: save last search, and cursor position.
  " @/ = from the registry named /
  let save_hist=@/


  let save_line = line(".")
  let save_column = col(".")
  " Do the business:
  "
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=save_hist
  call cursor(save_line, save_column)
endfunction

" }}}

" transpose {{{
" from https://github.com/tpope/vim-rsi
function! s:transpose() abort
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


function ClosePrev()
  if pumvisible() == 0
    pclose
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""
