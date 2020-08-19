" call loadview and mkview when appropriate
if exists('g:loaded_auto_save')
  finish
end
let g:loaded_auto_save = 1

" auto save view {{{
"  TODO: this could be better {{{
"" stolen from vim.wiki http://vim.wikia.com/wiki/Make_views_automatic
let g:skipview_files = [
            \ '[EXAMPLE PLUGIN BUFFER]',
            \ ]

let g:skipview_filetypes = ['help', 'gitcommit']

function NotInternalBuffer()
    " Buffer is marked as not a file
    if has('quickfix') && &buftype =~ 'nofile'
        return 0
    endif
    " File does not exist on disk
    if empty(glob(expand('%:p')))
        return 0
    endif
    " check the file path
    if index(g:skipview_files, expand('%')) >= 0
        return 0
    endif
    " check the file type
    if index(g:skipview_filetypes, &filetype ) >= 0
        return 0
    endif
    " using t-pops obsession
    if exists('g:this_obsession')
        return 0
    endif
    return 1
endfunction
"" }}}

augroup AutoSaveView
    autocmd!
    " Autosave & Load Views.
    autocmd BufWritePost,BufLeave,WinLeave,InsertLeave ?*
          \ if NotInternalBuffer() | silent! mkview | endif

    autocmd BufWinEnter ?* if NotInternalBuffer() | silent! loadview | endif
augroup end
" }}}
