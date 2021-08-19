if !exists('g:vscode')
    " enable tabline
    let g:airline#extensions#tabline#enabled = 1
    " let g:airline#extensions#tabline#left_sep = ''
    " let g:airline#extensions#tabline#left_alt_sep = ''
    " let g:airline#extensions#tabline#right_sep = ''
    " let g:airline#extensions#tabline#right_alt_sep = ''

    " enable powerline fonts
    let g:airline_powerline_fonts = 1
    " let g:airline_left_sep = ''
    " let g:airline_right_sep = ''

    " Switch to your current theme
    let g:airline_theme = 'dark_plus'

    " Always show tabs
    set showtabline=2

    " We don't need to see things like -- INSERT -- anymore
    set noshowmode

    " Better rendering for windows
    " https://github.com/vim-airline/vim-airline/wiki/FAQ
    if (has('win32') || has('win64')) && has('directx')
        set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
    endif
endif
