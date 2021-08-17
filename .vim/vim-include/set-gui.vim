" Default font for gVim in Windows
if has("gui_running")
    set guifont=JetBrains_Mono:h12:cANSI:qDRAFT
    set lines=50 columns=120
endif

" deal with colors
if !has('gui_running')
    set t_Co=256
endif
if has('win32') || has('win64') || (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
    " screen does not (yet) support truecolor
    set termguicolors
endif
set background=dark
if has('nvim')
    let g:vscode_style = "dark"
    colorscheme vscode
else
    colorscheme dark_plus
endif

