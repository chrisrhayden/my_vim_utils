if exists('g:loaded_my_preserve')
  finish
end
let g:loaded_my_preserve = 1

function preserve#Preserve(cmd)
  " http://vimcasts.org/episodes/tidying-whitespace/
  " Preparation: save last search, and cursor position.
  " @/ = from the registry named /
  let l:save_hist=@/


  let l:save_line = line(".")
  let l:save_column = col(".")

  execute a:cmd


  " Clean up: restore previous search history, and cursor position
  let @/=l:save_hist

  call cursor(save_line, save_column)
endfunction
