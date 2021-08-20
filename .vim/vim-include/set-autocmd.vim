" TrimWhitespace from youtube: https://youtu.be/DogKdiRx7ls
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

function! SetUnsetQShortcut()
    if &ft == 'help'
        silent! unmap q:
    else
        map q: :q
    endif
endfunction

augroup COMILUV
    autocmd!
    "autocmd BufWritePre * :call TrimWhitespace()
    " Return to last edit position when opening files
    " It's some magic I picked up somewhere, no idea how it works
    " or what alternatives are out there
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " Remove auto commenting when pressing o or O
    autocmd FileType * set formatoptions-=o
    "autocmd BufEnter * :call SetUnsetQShortcut()
    autocmd FileType help nnoremap <buffer> q :q<CR>
    " Auto toggle cursorline
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
    " Auto reload if file was changed somewhere else (for autoread)
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
                \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
augroup END

