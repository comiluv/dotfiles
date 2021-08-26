" coc config
if !exists('g:vscode')
    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif

    " To avoid conflict with vim-endwise, use functions - see: https://github.com/tpope/vim-endwise/issues/105
    function! SendCY()
        call feedkeys("\<C-Y>", "t")
        return ""
    endfunction
    function! SendCR()
        call feedkeys("\<C-g>u\<CR>", "n")
        return ""
    endfunction
    function! SendCRCoc()
        call feedkeys("\<C-g>u\<CR>", "n")
        return ""
    endfunction
    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    if has('patch8.1.1068')
        inoremap <silent><expr> <cr> complete_info()["selected"] != "-1" ? coc#_select_confirm()
                    \: SendCRCoc()
    else
        imap <expr> <cr> pumvisible() ? SendCY() : SendCR()
    endif
    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap for rename current word
    nmap <F2> <Plug>(coc-rename)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        elseif (coc#rpc#ready())
            call CocActionAsync('doHover')
        else
            execute '!' . &keywordprg . " " . expand('<cword>')
        endif
    endfunction
    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')
endif
