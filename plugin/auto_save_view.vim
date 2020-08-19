" NOTES:
" from vim.wiki http://vim.wikia.com/wiki/Make_views_automatic
"
" loadview will warn/error for missing views
"
" call loadview and mkview when appropriate
if exists('g:loaded_auto_save')
  finish
end
let g:loaded_auto_save = 1

let g:skip_filetypes = ['gitcommit']

function NormalBuffer()
    " if not empty then the buffer is a `special-buffer` like help,
    " this is pretty subtle, i wonder how many plugins use this well
    if empty(&buftype) != 1
        return v:false

    " if a plugin doesn't use buftype well i doubt it will use hidden but idk
    elseif &buflisted == 'nobuflisted'
        return v:false

    " skip the given file types
    elseif index(g:skip_filetypes, &filetype) >= 0
        return v:false

    " using t-pops obsession, obsession will handle views or something
    elseif exists('g:this_obsession')
        return v:false

    endif

    " else its a normal file
    return v:true
endfunction

augroup AutoSaveView
    autocmd!
    autocmd BufWritePost,BufLeave,WinLeave,InsertLeave ?*
          \ if NormalBuffer() | mkview | endif

    autocmd BufWinEnter ?* if NormalBuffer() | loadview | endif
augroup end
