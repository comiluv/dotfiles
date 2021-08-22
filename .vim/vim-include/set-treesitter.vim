if has('nvim') && !exists("g:vscode")
lua <<EOF
    require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true }
        }
EOF
endif
