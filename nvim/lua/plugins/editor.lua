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
			{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
			{
				"<C-p>",
				function()
					vim.fn.system("git rev-parse --is-inside-work-tree")
					if vim.v.shell_error == 0 then
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
		},
		config = function()
			-- stylua: ignore
			local file_ignore_patterns =
{"^.*%.7z$","^.*%.aux$","^.*%.avi$","^.*%.bak$","^.*%.bib$","^.*%.class$","^.*%.cls$","^.*%.cmi$","^.*%.cmo$","^.*%.doc$","^.*%.docx$","^.*%.dvi$","^.*%.flac$","^.*%.flv$","^.*%.gem$","^.*%.gif$","^.*%.hi$","^.*%.ico$","^.*%.jpeg$","^.*%.jpg$","^.*%.log$","^.*%.min.*%.js$","^.*%.min%.js$","^.*%.mov$","^.*%.mp3$","^.*%.mp4$","^.*%.mpg$","^.*%.nav$","^.*%.o$","^.*%.obj$","^.*%.ods$","^.*%.odt$","^.*%.ogg$","^.*%.opus$","^.*%.out$","^.*%.pdf$","^.*%.pem$","^.*%.png$","^.*%.rar$","^.*%.rbc$","^.*%.rbo$","^.*%.settings$","^.*%.sty$","^.*%.svg$","^.*%.swp$","^.*%.swp.*%.$","^.*%.tar$","^.*%.tar%.bz2$","^.*%.tar%.gz$","^.*%.tar%.xz$","^.*%.tgz$","^.*%.toc$","^.*%.wav$","^.*%.webm$","^.*%.xcf$","^.*%.xls$","^.*%.xlsx$","^.*%.zip$","^.*/%.bundle/.*$","^.*/%.sass%-cache/.*$","^.*/vendor/cache/.*$","^.*/vendor/gems/.*$","^.*%~$","^%._.*$","^%.git$","^%.hg$","^%.svn$","^Thumbs%.db$","^Zend$","^intermediate/.*$","^publish/.*$","^vendor$"}
			require("telescope").setup({
				defaults = { file_ignore_patterns = file_ignore_patterns },
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
		event = { "BufRead", "BufNewFile" },
		config = true,
	},

	{
		"rktjmp/highlight-current-n.nvim",
		event = { "BufRead", "BufNewFile" },
		config = function()
			local clear_search_hl_group = vim.api.nvim_create_augroup("ClearSearchHL", {})
			vim.api.nvim_create_autocmd("CmdlineEnter", {
				group = clear_search_hl_group,
				pattern = { "/", "\\?" },
				callback = function()
					vim.opt.hlsearch = true
				end,
			})
			vim.api.nvim_create_autocmd("CmdlineLeave", {
				group = clear_search_hl_group,
				pattern = { "/", "\\?" },
				callback = function()
					vim.opt.hlsearch = false
				end,
			})
			vim.api.nvim_create_autocmd("CmdlineLeave", {
				group = clear_search_hl_group,
				pattern = { "/", "\\?" },
				callback = function()
					require("highlight_current_n")["/,?"]()
				end,
			})

			local hcn = require("highlight_current_n")
			local feedkeys = vim.api.nvim_feedkeys
			vim.keymap.set("n", "n", function()
				hcn.n()
				return feedkeys("zzzv", "n", false)
			end, { expr = true, remap = false })
			vim.keymap.set("n", "N", function()
				hcn.N()
				return feedkeys("zzzv", "n", false)
			end, { expr = true, remap = false })
			vim.keymap.set("n", "*", "*N", { remap = true })
			vim.keymap.set("n", "#", "#N", { remap = true })
		end,
	},
}
