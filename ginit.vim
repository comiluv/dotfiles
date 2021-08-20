" use tabline from Airline plugin
GuiTabline 0

" nvim-qt font settings
GuiFont! JetBrainsMono Nerd Font Mono:h12
let s:fontsize = 12

" change font size with Ctrl + mouse-wheel
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! JetBrainsMono Nerd Font Mono:h" . s:fontsize
endfunction
noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
