" auto save view {{{

" stolen from vim.wiki http://vim.wikia.com/wiki/Make_views_automatic
let g:skipview_files = [
            \ '[EXAMPLE PLUGIN BUFFER]'
            \ ]

function! MakeFileCheck()
    if has('quickfix') && &buftype =~ 'nofile'
        " Buffer is marked as not a file
        return 0
    endif
    if empty(glob(expand('%:p')))
        " File does not exist on disk
        return 0
    endif
    if len($TEMP) && expand('%:p:h') == $TEMP
        " We're in a temp dir
        return 0
    endif
    if len($TMP) && expand('%:p:h') == $TMP
        " Also in temp dir
        return 0
    endif
    if index(g:skipview_files, expand('%')) >= 0
        " File is in skip list
        return 0
    endif
    " i added
    if exists('g:this_obsession')
        " using t-pops obsession
        return 0
    endif
    if &filetype == 'help'
        " this is a help file
        return 0
    endif
    if &filetype == 'gitcommit'
        " gitcommit
        return 0
    endif
    return 1
endfunction

" }}}