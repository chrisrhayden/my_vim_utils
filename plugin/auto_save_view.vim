" NOTES:
" from vim.wiki http://vim.wikia.com/wiki/Make_views_automatic
"
" there are too many edge cases to fully ignore every special-buffer from every
" plugin, so using silent and ether ignoring the vim error or letting weird
" buffers make views is fine
"
" loadview will warn/error for missing views
"
" this doesn't really fit and i dont use obsession
" t-pops obsession, obsession will handle views or something
" if exists('g:this_obsession')
"     return v:true
" endif
"
" call loadview and mkview when appropriate
if exists('g:loaded_auto_save')
  finish
end
let g:loaded_auto_save = 1

" this is sort of a last resort to ignore buffers that are special but still
" are treated like normal files
let g:skip_filetypes = ['gitcommit']

function SpecialBuffer()
    " if not empty then the buffer is a `special-buffer` like help and plugins
    " that use this well like tagbar
    if empty(&buftype) != 1
        return v:true

    " if a plugin doesn't use buftype well i doubt it will use buflisted but idk
    elseif &buflisted == 'nobuflisted'
        return v:true

    " skip the given file types
    elseif index(g:skip_filetypes, &filetype) >= 0
        return v:true

    endif

    " else its a normal file
    return v:false
endfunction

augroup AutoSaveView
    autocmd!

    autocmd BufWritePost,BufLeave,WinLeave,InsertLeave ?*
          \ if SpecialBuffer() == v:false | mkview | endif

    autocmd BufWinEnter ?*
          \ if SpecialBuffer()  == v:false | silent! loadview | endif
augroup end
