return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", vim.cmd.LazyGit, silent = true, desc = [[LazyGit (A-\ is ESC)]] },
		},
	},

	-- show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "VeryLazy", "BufNewFile", "InsertEnter" },
		main = "ibl",
		opts = {
			enabled = true,
			exclude = { filetypes = vim.g.info_filetype },
			indent = { char = "┆" },
		},
	},

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = { "LspAttach" },
		config = true,
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
		ft = { "css" },
		opts = {
			filetypes = { "css" },
			user_default_options = { css = true },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = true,
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
		config = true,
	},

	{
		"folke/which-key.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = true,
	},
}
