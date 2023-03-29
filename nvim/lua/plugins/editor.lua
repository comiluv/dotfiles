return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<CMD>Telescope find_files<Cr>", desc = "Telescope find files" },
			{
				"<C-p>",
				function()
					vim.fn.system("git rev-parse --is-inside-work-tree")
					if vim.v.shell_error == 0 then
						require("telescope.builtin").git_files()
					else
						require("telescope.builtin").find_files()
					end
				end,
				desc = "Telescope find git files",
			},
			{ "<leader>ps", function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > "), use_regex = true, })
			end

			, desc = "Telescope Live Grep" },
			{ "<leader>pb", "<CMD>Telescope buffers<Cr>", desc = "Telescope buffers" },
		},
		config = function()
			require("telescope").setup({
				defaults = { file_ignore_patterns = { "%.class", }, },
			})
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

