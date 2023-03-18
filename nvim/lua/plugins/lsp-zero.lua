return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		event = { "BufRead", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					-- Snippet Collection (Optional)
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		config = function()
			-- https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs
			require("luasnip").config.setup({
				ext_opts = {
					[require("luasnip.util.types").choiceNode] = {
						active = {
							virt_text = { { "●", "GruvboxOrange" } },
						},
					},
					[require("luasnip.util.types").insertNode] = {
						active = {
							virt_text = { { "●", "GruvboxBlue" } },
						},
					},
				},
			})

			local lsp = require("lsp-zero")
			-- Learn the keybindings, see :help lsp-zero-keybindings
			-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
			lsp.preset("recommended")

			lsp.ensure_installed({
				"lua_ls",
			})

			-- Fix Undefined global 'vim'
			lsp.configure("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			lsp.configure("grammarly", {
				filetypes = { "markdown", "text" },
			})

			-- Have to do this or lsp-zero won't let nvim-jdtls handle jdtls
			lsp.skip_server_setup({ "jdtls" })

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- https://github.com/windwp/nvim-autopairs
				["<C-e>"] = cmp.mapping.abort(),
				["<C-Space>"] = cmp.mapping.complete(),
			})

			-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
			local luasnip = require("luasnip")
			cmp_mappings["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
				elseif luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" })
			cmp_mappings["<S-Tab>"] = cmp.mapping(function(fallback)
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
					completeopt = "menu,menuone,noinsert,noselect",
				},
			})

			lsp.set_preferences({
				suggest_lsp_servers = true,
				sign_icons = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "Go to implementation" }
					)
					vim.keymap.set(
						"n",
						"gr",
						require("telescope.builtin").lsp_references,
						{ buffer = ev.buf, desc = "Go to references" }
					)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
					vim.keymap.set(
						"n",
						"<leader>vws",
						vim.lsp.buf.workspace_symbol,
						{ buffer = ev.buf, desc = "Workspace symbol" }
					)
					vim.keymap.set(
						"n",
						"<leader>vd",
						vim.diagnostic.open_float,
						{ buffer = ev.buf, desc = "View diagnostic" }
					)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Next diagnostic" })
					vim.keymap.set(
						"n",
						"[d",
						vim.diagnostic.goto_prev,
						{ buffer = ev.buf, desc = "Previous diagnostic" }
					)
					vim.keymap.set(
						"n",
						"<leader>vca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "Code action" }
					)
					vim.keymap.set(
						"n",
						"<leader>vrr",
						vim.lsp.buf.references,
						{ buffer = ev.buf, desc = "Open references" }
					)
					vim.keymap.set(
						"n",
						"<leader>vrn",
						":IncRename <C-r><C-w>",
						{ buffer = ev.buf, desc = "Rename symbol" }
					)
					vim.keymap.set(
						"i",
						"<C-h>",
						vim.lsp.buf.signature_help,
						{ buffer = ev.buf, desc = "Signature help" }
					)
					vim.keymap.set(
						"n",
						"<space>wa",
						vim.lsp.buf.add_workspace_folder,
						{ buffer = ev.buf, desc = "Workspace Add folder" }
					)
					vim.keymap.set(
						"n",
						"<space>wr",
						vim.lsp.buf.remove_workspace_folder,
						{ buffer = ev.buf, desc = "Worksapce Remove folder" }
					)
					vim.keymap.set("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { buffer = ev.buf, desc = "Workspace List folders" })
				end,
			})

			lsp.on_attach(function(client, bufnr)
				-- get nvim-navic working with multiple tabs
				if client.server_capabilities["documentSymbolProvider"] then
					require("nvim-navic").attach(client, bufnr)
				end
			end)

			lsp.setup()

			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},

	-- java language server plugin because lsp-zero (and lspconfig to extent) doesn't work
	-- see after/ftplugin/java.lua
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
	},

	-- debug adapater protocol
	{
		"mfussenegger/nvim-dap",
		event = { "BufRead", "BufNewFile" },
	},

	-- inject LSP diagnostics, code actions, formatting etc.
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufRead", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local sources = {
				-- python
				require("null-ls").builtins.formatting.black.with({
					extra_args = { "--line-length=120" },
				}),
				require("null-ls").builtins.formatting.isort,
				require("null-ls").builtins.formatting.stylua,
				require("null-ls").builtins.formatting.google_java_format,
			}
			require("null-ls").setup({ sources = sources })
		end,
	},
}

