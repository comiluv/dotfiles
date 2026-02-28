return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"comiluv/telescope-git-file-history.nvim",
			"kkharji/sqlite.lua",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
			{
				"<C-p>",
				function()
					if vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait().code == 0 then
						vim.api.nvim_exec2("Telescope git_files", {})
					else
						vim.api.nvim_exec2("Telescope find_files", {})
					end
				end,
				desc = "Telescope find git files",
			},
			{
				"<leader>ps",
				function()
					require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > "), use_regex = true })
				end,
				desc = "Telescope grep string",
			},
			{ "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Telescope current buffer",
			},
			{ "<leader>ca", vim.lsp.buf.code_action, "Telescope Code action" },
			{
				"<leader>bh",
				function()
					if vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait().code == 0 then
						vim.api.nvim_exec2("Telescope git_file_history", {})
					end
				end,
				desc = "Telescope buffer history",
			},
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					history = {
						path = vim.g.stdpath_data .. "/databases/telescope_history.sqlite3",
						limit = 100,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("git_file_history")
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		build = "make",
		cond = vim.fn.executable("make") == 1,
	},

	-- fast file-finding
	{
		"danielfalk/smart-open.nvim",
		keys = {
			{ "<leader>r", "<cmd>Telescope smart_open<cr>", desc = "Telescope recent files" },
		},
		branch = "0.2.x",
		config = function()
			require("telescope").load_extension("smart_open")
		end,
		dependencies = {
			"kkharji/sqlite.lua",
			-- Only required if using match_algorithm fzf
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
}
