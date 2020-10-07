if exists('g:loaded_clear_whitespace')
  finish
endif
let g:loaded_clear_whitespace = 1

command ClearWhitespace :call preserve#Preserve('%s/\s\+$//e')

nnoremap <leader>cw :ClearWhitespace<cr>:nohlsearch<CR>
