if has('nvim') && !exists('g:vscode')
    " LSP config (the mappings used in the default file don't quite work right)
    nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> [g <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
    nnoremap <silent> ]g <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
    nnoremap <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>

    " auto-format
    augroup lsp_autofmt
        autocmd!
        autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
        autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
        autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)
    augroup END
endif
