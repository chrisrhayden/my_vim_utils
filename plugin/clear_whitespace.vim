if exists('g:loaded_clear_whitespace')
  finish
endif
let g:loaded_clear_whitespace = 1

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

command ClearWhitespace :call Preserve('%s/\s\+$//e')

nnoremap <leader>cw :ClearWhitespace<cr>:nohlsearch<CR>
