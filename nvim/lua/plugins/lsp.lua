return {
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		dependencies = {
			"mason.nvim",
			"mason-org/mason-lspconfig.nvim",
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
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
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
				yamlls = {
					settings = {
						yaml = {
							format = {
								enable = true,
							},
						},
					},
				},
				grammarly = {
					filetypes = { "markdown", "text" },
				},
				clangd = {
					cmd = { "clangd", "--header-insertion=never" },
				},
				powershell_es = {
					bundle_path = vim.fn.stdpath("data") .. "\\mason\\packages\\powershell-editor-services",
				},
			},
			skip_server_setup = { jdtls = true, rust_analyzer = true, ruff = true },
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			setup = {
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
			ensure_installed = {},
		},

		---@class opts
		config = function(_, opts)
			-- create keymaps
			require("lsp_keymaps").create_keymaps()

			vim.diagnostic.config(opts.diagnostics)

			local servers = opts.servers
			local lsp_capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				if opts.skip_server_setup[server] then
					return
				end
				local server_opts = vim.tbl_deep_extend("force", {}, {
					capabilities = vim.deepcopy(lsp_capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				vim.lsp.config(server, server_opts)
				vim.lsp.enable(server)
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
		"mason-org/mason.nvim",
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
				-- web
				"deno",
				"css-lsp",
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

	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		dependencies = { "mason-org/mason.nvim" },
		version = "^1",
	},

	-- java language server plugin to further utilize lsp capabilities
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
		opts = function(_, opts)
			opts = opts or {}
			-- This snippet will automatically detect which formatters take too long to run synchronously and will run them async on save instead.
			vim.g.slow_format_filetypes = vim.g.slow_format_filetypes or {}
			local format = {
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					if vim.g.slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					local function on_format(err)
						if err and err:match("timeout$") then
							vim.g.slow_format_filetypes[vim.bo[bufnr].filetype] = true
						end
					end

					return { timeout_ms = 500, lsp_format = "fallback" }, on_format
				end,

				format_after_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					if not vim.g.slow_format_filetypes[vim.bo[bufnr].filetype] then
						return
					end
					return { lsp_format = "fallback" }
				end,

				formatters_by_ft = {
					javascript = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
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
			opts = vim.tbl_deep_extend("force", opts, format)
			return opts
		end,
		init = function()
			-- Create user commands to quickly enable/disable autoformatting
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
					vim.notify("Autoformat disabled (buffer)", vim.log.levels.INFO)
				else
					vim.g.disable_autoformat = true
					vim.notify("Autoformat disabled (global)", vim.log.levels.INFO)
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
				vim.notify("Autoformat enabled", vim.log.levels.INFO)
			end, {
				desc = "Re-enable autoformat-on-save",
			})
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		config = function()
			local lint = require("lint")
			table.insert(lint.linters.mypy.args, "--ignore-missing-imports")
			local new_ruff_args = { "--ignore", "E741" }
			lint.linters.ruff.args = vim.list_extend(lint.linters.ruff.args, new_ruff_args)

			lint.linters_by_ft = {
				python = { "mypy", "ruff" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					-- Only run the linter in modifiable buffers
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
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
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true,
		dependencies = {
			"mason-org/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		event = { "LspAttach" },
		opts = {},
	},
}
