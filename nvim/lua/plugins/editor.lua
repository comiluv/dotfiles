return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<CMD>Telescope find_files<Cr>", desc = "Find files" },
			{ "<C-p>", "<CMD>Telescope git_files<Cr>", desc = "Find git files" },
			{ "<leader>ps", "<CMD>Telescope live_grep<Cr>", desc = "Live grep" },
		},
		config = function()
			require("telescope").setup({})
			require("telescope").load_extension("fzf")
		end,
	},

	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- auto detect indentation
	{
		"Darazaki/indent-o-matic",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	-- auto locate last location in the file
	{
		"vladdoster/remember.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = true,
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Open Undotree" },
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
}

