local ok, lsp = pcall(require,'lsp-zero')
if not ok then return end
-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
lsp.preset('recommended')

lsp.ensure_installed({
	'lua_ls',
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
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

-- Have to do this or lsp-zero won't let nvim-jdtls handle jdtls
lsp.skip_server_setup({'jdtls',})

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

-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local luasnip = require'luasnip'
cmp_mappings['<Tab>'] = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
		-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
		-- they way you will only jump inside the snippet region
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end, {"i","s"})
cmp_mappings['<S-Tab>'] = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, { "i", "s" })

-- fix lsp-zero auto selecting first item: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/advance-usage.md#dont-preselect-first-match
lsp.setup_nvim_cmp({
	preselect = cmp.PreselectMode.None,
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
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
	{ buffer = bufnr, desc = "Go to declaration"})
	vim.keymap.set("n", "gd", vim.lsp.buf.definition,
	{ buffer = bufnr, desc = "Go to definition"})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
	{ buffer = bufnr, desc = "Go to implementation"})
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references,
	{ buffer = bufnr, desc = "Go to references"})
	vim.keymap.set("n", "K", vim.lsp.buf.hover,
	{ buffer = bufnr, })
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol,
	{ buffer = bufnr, desc = "Workspace symbol"})
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float,
	{ buffer = bufnr, desc = "View diagnostic"})
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
	{ buffer = bufnr, desc = "Next diagnostic"})
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
	{ buffer = bufnr, desc = "Previous diagnostic"})
	vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action,
	{ buffer = bufnr, desc = "Code action"})
	vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references,
	{ buffer = bufnr, desc = "Open references"})
	vim.keymap.set("n", "<leader>vrn", ":IncRename <C-r><C-w>",
	{ buffer = bufnr, desc = "Rename symbol"})
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help,
	{ buffer = bufnr, desc = "Signature help"})
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder,
	{ buffer = bufnr, desc = "Workspace Add folder" })
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
	{ buffer = bufnr, desc = "Worksapce Remove folder" })
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end,
	{ buffer = bufnr, desc = "Workspace List folders" })

	-- get nvim-navic working with multiple tabs
	if client.server_capabilities["documentSymbolProvider"] then
		require("nvim-navic").attach(client, bufnr)
	end
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = false,
})

