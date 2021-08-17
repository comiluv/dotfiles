" Neovim use separately installed python3.9 when in Ubuntu 20.04 LTS
if has('nvim')
    " Disable Python 2 support
    let g:loaded_python_provider = 0
    if has('unix')
        let g:python3_host_prog=expand('/usr/bin/python3.9')
    else
        let g:python3_host_prog=expand('C:\python39\python.exe')
    endif
endif

" Neovim terminal mode remaps
if has('nvim')
    " Use Escape key like a sane person
    tnoremap <ESC> <C-\><C-n>
    " Remap in case ESC key input is needed
    tnoremap <A-\> <ESC>
    " Move out from terminal window with alt key shortcuts
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    " Paste in terminal mode
    tnoremap <expr> <C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
endif
