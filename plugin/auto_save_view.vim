" call loadview and mkview when appropriate
if exists('g:loaded_auto_save')
  finish
end
let g:loaded_auto_save = 1

" auto save view {{{
"" stolen from vim.wiki http://vim.wikia.com/wiki/Make_views_automatic
" let g:skipview_files = [ '[EXAMPLE PLUGIN BUFFER]' ]
let g:skipview_filetypes = ['gitcommit']

function NotInternalBuffer()
    " if not empty then its a special buffer like help,
    " this is pretty subtle, i wonder how many plugins use this well
    if &buftype != ''
        return v:false

    " skip the given file types
    elseif index(g:skipview_filetypes, &filetype) >= 0
        return v:false

    " using t-pops obsession, obsession will handle views or something
    elseif exists('g:this_obsession')
        return v:false
    endif

    return v:true
endfunction

augroup AutoSaveView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePost,BufLeave,WinLeave,InsertLeave ?*
          \ if NotInternalBuffer() | mkview | endif

    autocmd BufWinEnter ?* if NotInternalBuffer() | loadview | endif
augroup end
" }}}
