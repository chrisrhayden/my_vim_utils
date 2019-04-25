" from reddit
" https://redd.it/7iy03o
function! Relativize(v)
  if &number
    let &relativenumber = a:v
  endif
endfunction

augroup RelativizeAu
  autocmd!
  " autocmd InsertLeave * call Relativize(1)
  " autocmd InsertEnter * call Relativize(0)
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END
