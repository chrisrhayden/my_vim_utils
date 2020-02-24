" unset relnumber when in insert mode but use both for normal mode
if exists('g:loaded_toggle_relnum')
  finish
end
let g:loaded_toggle_relnum = 1

set number
set relativenumber

" stolen from
" https://github.com/jeffkreeftmeijer/vim-numbertoggle/

augroup RelativizeNum
  autocmd!
  autocmd InsertLeave * if &number | set relativenumber  | endif
  autocmd InsertEnter * if &number | set norelativenumber | endif
augroup END

" BufWinEnter,FocusGained,InsertLeave,WinEnter
" BufWinLeave,FocusLost,InsertEnter,WinLeave
