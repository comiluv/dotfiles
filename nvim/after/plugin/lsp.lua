local ok, lsp = pcall(require,'lsp-zero')
if not ok then return end
-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
lsp.preset('recommended')

lsp.ensure_installed({
    'sumneko_lua',
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            },
            telemetry = {
                enable = false,
            },
        }
    }
})

lsp.configure('grammarly',{
    filetypes = {"markdown", "text"},
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- https://github.com/windwp/nvim-autopairs
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-Space>'] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

-- fix lsp-zero auto selecting first item: https://stackoverflow.com/questions/74688630/make-nvim-cmp-not-autoselect-the-1st-option
lsp.setup_nvim_cmp({
    preselect = 'none',
    mapping = cmp_mappings,
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
    },
})

lsp.set_preferences({
    suggest_lsp_servers = true,
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})

lsp.on_attach(function(client, bufnr)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
    { buffer = bufnr, desc = "Go to definition"})
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
    { buffer = bufnr, })
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
    { buffer = bufnr, desc = "Workspace symbol"})
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end,
    { buffer = bufnr, desc = "View diagnostic"})
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end,
    { buffer = bufnr, desc = "Next diagnostic"})
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end,
    { buffer = bufnr, desc = "Previous diagnostic"})
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end,
    { buffer = bufnr, desc = "Code action"})
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end,
    { buffer = bufnr, desc = "Open references"})
    vim.keymap.set("n", "<leader>vrn", ":IncRename <C-r><C-w>",
    { buffer = bufnr, desc = "Rename symbol"})
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
    { buffer = bufnr, desc = "Signature help"})

    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local options = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, options)
        end
    })
    -- get nvim-navic working with multiple tabs
    if client.server_capabilities["documentSymbolProvider"] then
        require("nvim-navic").attach(client, bufnr)
    end
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
})

