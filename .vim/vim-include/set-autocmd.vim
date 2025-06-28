function! TrimWhitespace()
    " Only trim "normal" buffers
    if &buftype != ''
        return
    end
    if &ft =~ 'markdown\|ruby\|javascript\|perl'
	    return
    end
    let l:save = winsaveview()
    keepjumps keeppatterns %s/\s\+$//e
    keepjumps keeppatterns silent! 0;/^\%(\_s*\S\)\@!/,$d
    keepjumps keeppatterns $put _
    call winrestview(l:save)
endfunction

augroup MYGROUP
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
    " Return to last edit position when opening files
    " To quote Primeagen, "It's some magic I picked up somewhere, no idea how it works
    " or what alternatives are out there"
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " Remove auto commenting when pressing o or O
    autocmd FileType * set formatoptions-=ro
    " Press q to instantly quit the buffer
    autocmd FileType help,qf,man,notify,fugitive,vim-plug nnoremap <buffer><nowait> q <CMD>q<CR>
    autocmd TerminalWinOpen * nnoremap <buffer><nowait> q <CMD>q<CR>
augroup END

