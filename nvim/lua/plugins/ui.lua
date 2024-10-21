return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", vim.cmd.LazyGit, silent = true, desc = [[LazyGit]] },
		},
	},

	-- show indent lines
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function(_, opts)
			local filetypes = require("utils").array_to_table(vim.g.info_filetype, true)
			local indent = {
				indent = {
					enable = true,
					chars = { "┆" },
					exclude_filetypes = filetypes,
				},
			}
			opts = vim.tbl_deep_extend("force", opts, indent)
			return opts
		end,
	},

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = { "LspAttach" },
		opts = {},
	},

	-- show lightbulb where code action can be taken
	{
		"kosayoda/nvim-lightbulb",
		event = { "LspAttach" },
		opts = {
			autocmd = { enabled = true },
		},
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css", "json" },
		opts = {
			filetypes = { "css", "json" },
			user_default_options = { mode = "virtualtext", names = false, css = true },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = function()
			require("treesitter-context").setup({ max_lines = 60 })
			vim.api.nvim_create_autocmd({ "BufReadPre" }, {
				group = vim.api.nvim_create_augroup("ts-context-group", {}),
				callback = function(event)
					local ok, size = pcall(vim.fn.getfsize, event.file)
					if not ok or size > 1024 * 1024 then -- 1 MB
						vim.cmd.TSContextDisable()
						return
					end
					vim.cmd.TSContextEnable()
				end,
			})
		end,
	},

	-- better quickfix list
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
		opts = {},
	},

	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		opts = {},
	},

	{
		"folke/which-key.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		opts = {},
	},

	-- show LSP diagnostics in multiple lines
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = { "LspAttach" },
		config = function()
			require("lsp_lines").setup({})
			vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
			vim.keymap.set("", "<leader>l", function()
				local config = vim.diagnostic.config() or {}
				if config.virtual_text then
					vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
				else
					vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
				end
			end, { desc = "LSP: Toggle lsp_lines" })
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
}
