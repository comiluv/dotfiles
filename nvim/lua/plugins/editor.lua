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
			local file_ignore_patterns =
{"^.*%.7z$","^.*%.aux$","^.*%.avi$","^.*%.bak$","^.*%.bib$","^.*%.class$","^.*%.cls$","^.*%.cmi$","^.*%.cmo$","^.*%.doc$","^.*%.docx$","^.*%.dvi$","^.*%.flac$","^.*%.flv$","^.*%.gem$","^.*%.gif$","^.*%.hi$","^.*%.ico$","^.*%.jpeg$","^.*%.jpg$","^.*%.log$","^.*%.min.*%.js$","^.*%.min%.js$","^.*%.mov$","^.*%.mp3$","^.*%.mp4$","^.*%.mpg$","^.*%.nav$","^.*%.o$","^.*%.obj$","^.*%.ods$","^.*%.odt$","^.*%.ogg$","^.*%.opus$","^.*%.out$","^.*%.pdf$","^.*%.pem$","^.*%.png$","^.*%.rar$","^.*%.rbc$","^.*%.rbo$","^.*%.settings$","^.*%.sty$","^.*%.svg$","^.*%.swp$","^.*%.swp.*%.$","^.*%.tar$","^.*%.tar%.bz2$","^.*%.tar%.gz$","^.*%.tar%.xz$","^.*%.tgz$","^.*%.toc$","^.*%.wav$","^.*%.webm$","^.*%.xcf$","^.*%.xls$","^.*%.xlsx$","^.*%.zip$","^.*/%.bundle/.*$","^.*/%.sass%-cache/.*$","^.*/vendor/cache/.*$","^.*/vendor/gems/.*$","^.*%~$","^%._.*$","^%.git$","^%.hg$","^%.svn$","^Thumbs%.db$","^Zend$","^intermediate/.*$","^publish/.*$","^vendor$"}
			require("telescope").setup({
				defaults = { file_ignore_patterns = file_ignore_patterns, },
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

