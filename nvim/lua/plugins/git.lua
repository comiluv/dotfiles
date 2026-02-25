return {
	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		opts = {},
	},
	
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", vim.cmd.LazyGit, silent = true, desc = [[LazyGit]] },
		},
	},

	{
		dir = "~/telescope-git-file-history.nvim/",
		name = "telescope-git-file-history.nvim",
		lazy = true,
		dependencies = { "tpope/vim-fugitive" },
	},
}