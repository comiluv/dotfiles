" see https://github.com/equalsraf/neovim-qt
" Enable Mouse
set mouse=a

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    let s:fontname = "Liga SFMono Nerd Font"
    :execute "GuiFont! " . s:fontname . ":h09"
    " GuiFont! FragmentMono NFM:h09
    GuiRenderLigatures 1
    " Fallback font for CJK characters
    set guifontwide=D2CodingLigature\ Nerd\ Font
    let s:fontsize = 09

    " change font size with Ctrl + mouse-wheel
    function! AdjustFontSize(amount)
        let s:fontsize = s:fontsize+a:amount
        :execute "GuiFont! ".s:fontname.":h" . s:fontsize
    endfunction
    noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
    noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
    inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
    inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

