return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", vim.cmd.LazyGit, silent = true, desc = [[Open LazyGit (A-\ is ESC)]] },
		},
	},

	-- show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufEnter", "BufNewFile", "InsertEnter" },
		opts = {
			enabled = true,
			filetype_exclude = vim.g.info_file_pattern,
			char_blankline = "┆",
			show_current_context = true,
			show_current_context_start = true,
			use_treesitter = false, -- false because treesitter indentation is still buggy in some languages
			use_treesitter_scope = true,
		},
	},

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},

	-- winbar plugin
	{
		"utilyre/barbecue.nvim",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		name = "barbecue",
		version = "*",
		opts = {
			create_autocmd = false,
			attach_navic = false,
		},
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function(_, opts)
			require("barbecue").setup(opts)

			local events = {
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
			}

			if vim.fn.has("nvim-0.9") == 1 then
				table.insert(events, "WinResized")
			else
				table.insert(events, "WinScrolled")
			end

			vim.api.nvim_create_autocmd(events, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		config = true,
	},

	-- show lightbulb where code action can be taken
	{
		"kosayoda/nvim-lightbulb",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		opts = {
			autocmd = { enabled = true },
		},
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css" },
		opts = {
			filetypes = { "css" },
			user_default_options = { css = true },
		},
	},

	{
		"SmiteshP/nvim-navic",
		lazy = true,
		opts = {
			lsp = {
				auto_attach = true,
			},
		},
	},
}
