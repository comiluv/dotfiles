return {
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"SmiteshP/nvim-navic",
		},
		---@class PluginLspOpts
		opts = function()
			return {
				-- options for vim.diagnostic.config()
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = { spacing = 4, prefix = "●" },
					severity_sort = true,
				},
				sign_icons = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "",
				},
				-- LSP Server Settings
				---@type lspconfig.options
				servers = {
					lua_ls = {
						-- mason = false, -- set to false if you don't want this server to be installed with mason
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
					},
					grammarly = {
						filetypes = { "markdown", "text" },
					},
				},
				skip_server_setup = { jdtls = true },
				-- you can do any additional lsp server setup here
				-- return true if you don't want this server to be setup with lspconfig
				---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
				setup = {
					clangd = function(_, opts)
						local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
						clangd_capabilities.offsetEncoding = { "utf-16" }
						opts.capabilities = clangd_capabilities
						require("lspconfig").clangd.setup(opts)
						return true
					end,
					-- example to setup with typescript.nvim
					-- tsserver = function(_, opts)
					--   require("typescript").setup({ server = opts })
					--   return true
					-- end,
					-- Specify * to use this function as a fallback for any server
					-- ["*"] = function(server, opts) end,
				},
			}
		end,
		---@param opts PluginLspOpts
		config = function(_, opts)
			-- create remaps
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

			-- register diagnostic icons
			for name, icon in pairs(opts.sign_icons) do
				name = "DiagnosticSign" .. name:gsub("^%a", string.upper)
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			require("mason").setup()

			local lspconfig = require("lspconfig")
			local servers = opts.servers
			local lsp_capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local lsp_attach = function(client, bufnr)
				if client.server_capabilities["documentSymbolProvider"] then
					require("nvim-navic").attach(client, bufnr)
				end
			end

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(lsp_capabilities),
					on_attach = lsp_attach,
				}, servers[server] or {})

				if opts.skip_server_setup[server] then
					return
				elseif opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				lspconfig[server].setup(server_opts)
			end

			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local available = have_mason and mlsp.get_available_servers() or {}
			local ensure_installed = {}

			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed })
				mlsp.setup_handlers({ setup })
			end
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"LuaSnip",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local luasnip = require("luasnip")
			return {
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- https://github.com/windwp/nvim-autopairs
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				}),
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = {
			-- Snippet Collection (Optional)
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function(_, opts)
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
			require("luasnip").setup(opts)
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
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = true,
	},
}

