return {
	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		keys = {
			{
				"<leader>gdt",
				mode = { "n", "x" },
				function()
					local gitsigns = require("gitsigns")
					gitsigns.toggle_deleted()
					gitsigns.toggle_linehl()
					gitsigns.toggle_word_diff()
				end,
				desc = "Git: toggle inline diffs",
			},
		},
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
		"comiluv/telescope-git-file-history.nvim",
		lazy = true,
		dependencies = { "tpope/vim-fugitive" },
	},
}
