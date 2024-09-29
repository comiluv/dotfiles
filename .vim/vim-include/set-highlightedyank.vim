" add plugin vim-highlightedyank support for vim<8.0.1394
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif
" modify highlight duration of the plugin
let g:highlightedyank_highlight_duration=40

