if has('nvim') && !exists('g:vscode')
lua <<EOF

require'nvim-treesitter.configs'.setup {
    matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    },
}

EOF
endif
