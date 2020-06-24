" keep functions i dont want to mess or see in my rc with here
if exists('g:loaded_my_utils')
  finish
endif
let g:loaded_my_utils = 1

" Preserve {{{
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

" clear whitespace {{{
command ClearWhitespace :call Preserve('%s/\s\+$//e')

nnoremap <leader>cw :ClearWhitespace<cr>:nohlsearch<CR>
" }}}

" overwrite <c-g> to print the full file path {{{
function MyFilePath() abort
  echo expand('%:p') . ' [' . line('.') . ' - ' . line('$') . ' lines]'
endfunction

nnoremap <c-g> :call MyFilePath()<cr>
" }}}
