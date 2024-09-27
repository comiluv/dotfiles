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
		opts = {
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
			skip_server_setup = { jdtls = true, rust_analyzer = true, ruff = true },
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
					opts.cmd = { "clangd", "--header-insertion=never" }
					require("lspconfig").clangd.setup(opts)
					return true
				end,
				-- example to setup with typescript.nvim
				-- ts_ls = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
			ensure_installed = {},
		},

		---@class opts
		config = function(_, opts)
			-- create remaps
			require("lsp_remaps").create_remaps()

			-- register diagnostic icons
			for name, icon in pairs(opts.sign_icons) do
				name = "DiagnosticSign" .. name:gsub("^%a", string.upper)
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			local lspconfig = require("lspconfig")
			local servers = opts.servers
			local lsp_capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {}, {
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
				-- java
				"jdtls",
				"google-java-format",
				-- c/c++
				"clangd",
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
					require("conform").format({ timeout_ms = 500, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format Buffer",
			},
		},
		opts = function()
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

					return { timeout_ms = 500, lsp_format = "fallback" }, on_format
				end,

				format_after_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					if not slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_format = "fallback" }
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
					isort = { args = { "-" } },
				},
			}
			return opts
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
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", mode = "n", desc = "Debug: Toggle Debugger Breakpoint" },
			{ "<leader>dr", "<cmd>DapContinue<cr>", mode = "n", desc = "Debug: Start or continue the debugger" },
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
				desc = "Debug: Test Python method",
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local debugpy_path = vim.fn.stdpath("data")
				.. "/mason/packages/debugpy/venv/"
				.. (vim.fn.has("win32") == 1 and "Scripts/python.exe" or "bin/python3")
			require("dap-python").setup(debugpy_path)
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true,
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},

	{
		"mrcjkb/rustaceanvim",
		enabled = false,
		version = "^5",
		dependencies = { "mason.nvim" },
		ft = { "rust", "cargo" },
	},

	{
		"saecki/crates.nvim",
		dependencies = "hrsh7th/nvim-cmp",
		event = { "BufRead Cargo.toml" },
		opts = {},
	},

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		event = { "LspAttach" },
		opts = {},
	},
}
