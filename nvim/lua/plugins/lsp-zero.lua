return {
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = function()
			return {
				-- options for vim.diagnostic.config()
				diagnostics = {
					underline = true,
					update_in_insert = false,
					virtual_text = { spacing = 4, prefix = "●" },
					severity_sort = true,
					float = { source = "always", border = "rounded" },
				},
				sign_icons = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "",
				},
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
				skip_server_setup = { jdtls = true, rust_analyzer = true },
				-- you can do any additional lsp server setup here
				-- return true if you don't want this server to be setup with lspconfig
				setup = {
					---@class opts
					clangd = function(_, opts)
						local clangd_capabilities =
							require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
						opts.capabilities = clangd_capabilities
						local on_attach = opts.on_attach
						opts.on_attach = function(client, bufnr)
							client.server_capabilities.signatureHelpProvider = false
							if on_attach then
								on_attach(client, bufnr)
							end
						end
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
				ensure_installed = {},
			}
		end,
		---@class opts
		config = function(_, opts)
			-- create remaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspRemaps", {}),
				callback = function(ev)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
					vim.keymap.set(
						"n",
						"gd",
						"<cmd>Telescope lsp_definitions<cr>",
						{ buffer = ev.buf, desc = "Go to definition" }
					)
					vim.keymap.set(
						"n",
						"gi",
						"<cmd>Telescope lsp_implementations<cr>",
						{ buffer = ev.buf, desc = "Go to implementation" }
					)
					vim.keymap.set(
						"n",
						"gr",
						"<cmd>Telescope lsp_references<cr>",
						{ buffer = ev.buf, desc = "List references" }
					)
					vim.keymap.set(
						"n",
						"go",
						"<cmd>Telescope lsp_type_definitions<cr>",
						{ buffer = ev.buf, desc = "Go to type definition" }
					)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
					vim.keymap.set(
						"n",
						"<leader>vws",
						vim.lsp.buf.workspace_symbol,
						{ buffer = ev.buf, desc = "Workspace symbol" }
					)
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = ev.buf, desc = "Show diagnostic" })
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
					vim.keymap.set("n", "<leader>x", function()
						require("telescope.builtin").diagnostics({ bufnr = 0 })
					end, { buffer = ev.buf, desc = "Diagnostics Quickfix" })
					vim.keymap.set("n", "<A-6>", function()
						require("telescope.builtin").diagnostics({ bufnr = 0 })
					end, { buffer = ev.buf, desc = "Diagnostics Quickfix" })
					vim.keymap.set(
						"n",
						"<leader>vca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "Code action" }
					)
					vim.keymap.set(
						"n",
						"<leader>vrr",
						"<cmd>Telescope lsp_references<cr>",
						{ buffer = ev.buf, desc = "Open references" }
					)
					vim.keymap.set("n", "<leader>ss", function()
						require("telescope.builtin").lsp_document_symbols({
							symbols = {
								"Class",
								"Function",
								"Method",
								"Constructor",
								"Interface",
								"Module",
								"Struct",
								"Trait",
								"Field",
								"Property",
							},
						})
					end, { buffer = ev.buf, desc = "Goto Symbol" })
					vim.keymap.set("n", "<leader>sS", function()
						require("telescope.builtin").lsp_workspace_symbols({
							symbols = {
								"Class",
								"Function",
								"Method",
								"Constructor",
								"Interface",
								"Module",
								"Struct",
								"Trait",
								"Field",
								"Property",
							},
						})
					end, { buffer = ev.buf, desc = "Goto Symbol (Workspace)" })
					vim.keymap.set("n", "<f2>", ":IncRename <C-r><C-w>", { buffer = ev.buf, desc = "Rename symbol" })
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
						{ buffer = ev.buf, desc = "Workspace Remove folder" }
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

			-- require("mason").setup()

			local lspconfig = require("lspconfig")
			local servers = opts.servers
			local lsp_capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(lsp_capabilities),
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

			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = opts.ensure_installed })
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
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			-- tabout required to register tab key remap
			"abecodes/tabout.nvim",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_select_page = { behavior = cmp.SelectBehavior.Select, count = 8 }
			local luasnip = require("luasnip")
			local neogen = require("neogen")
			local copilot = require("copilot.suggestion")
			return {
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-u>"] = cmp.mapping.select_prev_item(cmp_select_page),
					["<C-d>"] = cmp.mapping.select_next_item(cmp_select_page),
					["<up>"] = cmp.mapping.select_prev_item(cmp_select),
					["<down>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ select = true }),
					}),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item(cmp_select)
							else
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
							end
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif neogen.jumpable() then
							neogen.jump_next()
						elseif copilot.is_visible() then
							copilot.accept()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item(cmp_select)
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						elseif neogen.jumpable(true) then
							neogen.jump_prev()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "crates" },
				}),
				experimental = {
					ghost_text = false,
				},
			}
		end,
		config = function(_, opts)
			local cmp = require("cmp")
			cmp.setup(opts)
			cmp.event:on("menu_opened", function()
				vim.b.copilot_suggestion_hidden = true
			end)
			cmp.event:on("menu_closed", function()
				local luasnip = require("luasnip")
				if not (luasnip.jumpable(1) or luasnip.jumpable(-1)) then
					vim.b.copilot_suggestion_hidden = false
				end
			end)
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
			local luasnip_group = vim.api.nvim_create_augroup("LuaSnipCopilotGroup", {})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LuasnipInsertNodeEnter",
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = true
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LuasnipInsertNodeLeave",
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
			vim.api.nvim_create_autocmd("InsertLeave", {
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
		end,
		-- jsregexp setup see https://github.com/L3MON4D3/LuaSnip/issues/1190#issuecomment-2171656749
		build = "pwsh " .. vim.fn.stdpath("config") .. "/luasnip_jsregexp_build.ps1",
	},

	-- java language server plugin because lsp-zero (and lspconfig to extent) doesn't work
	-- see after/ftplugin/java.lua
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
	},

	{
		"stevearc/conform.nvim",
		version = "*",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ timeout_ms = 10000, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format Buffer",
			},
		},
		config = function()
			-- This snippet will automatically detect which formatters take too long to run synchronously and will run them async on save instead.
			local slow_format_filetypes = {}
			local opts = {
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					if slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					local function on_format(err)
						if err and err:match("timeout$") then
							slow_format_filetypes[vim.bo[bufnr].filetype] = true
						end
					end

					return { timeout_ms = 200, lsp_fallback = true }, on_format
				end,

				format_after_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					if not slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_fallback = true }
				end,

				formatters_by_ft = {
					javascript = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					python = { "isort", "black" },
					lua = { "stylua" },
					java = { "google_java_format" },
					rust = { "rust-analyzer" },
				},
				formatters = {
					google_java_format = {
						command = "google-java-format",
					},
				},
			}
			require("conform").setup(opts)
		end,
		init = function()
			-- Create user commands to quickly enable/disable autoformatting
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
					print("Autoformat disabled (buffer)")
				else
					vim.g.disable_autoformat = true
					print("Autoformat disabled (global)")
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
				print("Autoformat enabled")
			end, {
				desc = "Re-enable autoformat-on-save",
			})
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = function()
			local lint = require("lint")
			table.insert(lint.linters.mypy.args, "--ignore-missing-imports")
			local new_ruff_args = { "--ignore", "E741" }
			for i = 1, #new_ruff_args do
				lint.linters.ruff.args[#lint.linters.ruff.args + 1] = new_ruff_args[i]
			end

			lint.linters_by_ft = {
				python = { "mypy", "ruff" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		cmd = { "Mason", "MasonUpdate" },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- lua
				"lua-language-server",
				"stylua",
				-- python
				"pyright",
				"black",
				"isort",
				"ruff",
				"mypy",
				"debugpy",
				-- web
				"typescript-language-server",
				"css-lsp",
				"tailwindcss-language-server",
				"eslint-lsp",
				"prettierd",
				-- c/c++
				"clangd",
				-- java
				"jdtls",
				"google-java-format",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			-- implements ensure_installed behavior
			local registry = require("mason-registry")
			registry.refresh(function()
				for _, pkg_name in ipairs(opts.ensure_installed) do
					local pkg = registry.get_package(pkg_name)
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	},

	{
		"mfussenegger/nvim-dap",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		keys = {
			{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", mode = "n", desc = "Toggle Debugger Breakpoint" },
			{ "<leader>dr", "<cmd>DapContinue<cr>", mode = "n", desc = "Start or continue the debugger" },
		},
	},

	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		keys = {
			{
				"<leader>dpr",
				function()
					require("dap-python").test_method()
				end,
				mode = "n",
				desc = "Debug Python",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			local debugpy_path = os.getenv("LocalAppData")
				.. "/nvim-data/mason/packages/debugpy/venv/Scripts/python.exe"
			require("dap-python").setup(debugpy_path)
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.after.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		opts = {
			handlers = {},
		},
	},

	-- AI assisted diagnostics
	{
		"piersolenski/wtf.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			openai_model_id = "gpt-4o-mini",
		},
		keys = {
			{
				"gw",
				mode = { "n", "x" },
				function()
					require("wtf").ai()
				end,
				desc = "Debug diagnostic with AI",
			},
			{
				mode = { "n" },
				"gW",
				function()
					require("wtf").search()
				end,
				desc = "Search diagnostic with Google",
			},
		},
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		dependencies = "mason.nvim",
		lazy = false,
	},

	{
		"saecki/crates.nvim",
		dependencies = "hrsh7th/nvim-cmp",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup()
		end,
	},
}
