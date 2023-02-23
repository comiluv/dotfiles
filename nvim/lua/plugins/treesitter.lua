return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		cmd = "TSUpdate",
		event = { "BufRead", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			-- semantic highlighting
			"David-Kunz/markid",
			-- auto close block with end
			"RRethy/nvim-treesitter-endwise",
			-- auto close tags
			"windwp/nvim-ts-autotag",
			-- jump to matching parens
			{
				"andymass/vim-matchup",
				event = { "BufRead", "BufNewFile" },
				config = function()
					vim.g.matchup_matchparen_offscreen = { method = "popup" }
				end,
			},
		},
		opts = {
			ensure_installed = { "help", "c", "lua" },
			sync_install = false,
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,
			ignore_install = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true, disable = { "python" } },
			endwise = { enable = true }, -- "RRethy/nvim-treesitter-endwise",
			autotag = { enable = true }, -- "windwp/nvim-ts-autotag",
			-- markid = { enable = true }, -- "David-Kunz/markid",
			matchup = { enable = true }, -- "andymass/vim-matchup",
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}

