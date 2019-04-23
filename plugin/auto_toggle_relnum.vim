" relativenumber {{{
" from reddit
" https://redd.it/7iy03o
set number relativenumber

function! Relativize(v)
  if &number && g:my_auto_toggle_relnum == 1
    let &relativenumber = a:v
  endif
endfunction

augroup relativize
  autocmd!
  " autocmd InsertLeave * call Relativize(1)
  " autocmd InsertEnter * call Relativize(0)
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END
" }}}

