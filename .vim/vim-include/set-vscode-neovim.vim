" Settings that only apply to vscode-neovim extension.
" Unnecessary and possibly conflicting settings are masked by 'if
" !exists("g:vscode")' in other setting files
if exists('g:vscode')
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine
endif
