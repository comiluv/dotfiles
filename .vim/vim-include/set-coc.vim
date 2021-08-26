" coc config
if !exists('g:vscode')
    " Remap for rename current word
    nmap <F2> <Plug>(coc-rename)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
endif
