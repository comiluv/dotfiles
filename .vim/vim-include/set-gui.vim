" All of this is pointless in vscode-neovim
if !exists('g:vscode')
    " Default font for gVim in Windows
    if has("gui_running") || exists("g:neovide")
        set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h12
        "set lines=50 columns=120
    endif
    if has("gui_running")
        " Gvim remember window position and size
        " https://stackoverflow.com/questions/594838/is-it-possible-to-get-gvim-to-remember-window-size
        set sessionoptions+=resize,winpos
        " To enable the saving and restoring of screen positions.
        let g:screen_size_restore_pos = 1
        " To save and restore screen for each Vim instance.
        " This is useful if you routinely run more than one Vim instance.
        " For all Vim to use the same settings, change this to 0.
        let g:screen_size_by_vim_instance = 1

        function! ScreenFilename()
            if has('amiga')
                return "s:.vimsize"
            elseif has('win32')
                return $HOME.'\_vimsize'
            else
                return $HOME.'/.vimsize'
            endif
        endfunction

        function! ScreenRestore()
            " Restore window size (columns and lines) and position
            " from values stored in vimsize file.
            " Must set font first so columns and lines are based on font size.
            let f = ScreenFilename()
            if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
                let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
                for line in readfile(f)
                    let sizepos = split(line)
                    if len(sizepos) == 5 && sizepos[0] == vim_instance
                        silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
                        silent! execute "winpos ".sizepos[3]." ".sizepos[4]
                        return
                    endif
                endfor
            endif
        endfunction

        function! ScreenSave()
            " Save window size and position.
            if has("gui_running") && g:screen_size_restore_pos
                let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
                let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
                            \ (getwinposx()<0?0:getwinposx()) . ' ' .
                            \ (getwinposy()<0?0:getwinposy())
                let f = ScreenFilename()
                if filereadable(f)
                    let lines = readfile(f)
                    call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
                    call add(lines, data)
                else
                    let lines = [data]
                endif
                call writefile(lines, f)
            endif
        endfunction

        augroup gVimWindows
            autocmd!
            autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
            autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
        augroup END
    endif

    " deal with colors
    if !has('gui_running')
        set t_Co=256
    endif
    if has('termguicolors') || (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
        " screen does not (yet) support truecolor
        set termguicolors
    endif
    set background=dark
    colorscheme dark_plus
endif
