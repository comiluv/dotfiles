return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = vim.fn.has("win32") == 1
						and function(ev)
							local build_commands = {
								'cd "' .. ev.dir .. '"',
								'"C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Auxiliary\\Build\\vcvars64.bat"',
								"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release",
								"cmake --build build --config Release",
								"cmake --install build --prefix build",
							}
							local build_command_str = table.concat(build_commands, " && ")
							vim.fn.system(build_command_str)
						end
					or "make",
				cond = function()
					return vim.fn.has("win32") == 1 and vim.fn.executable("cmake") == 1
						or vim.fn.executable("make") == 1
				end,
			},
			{
				"nvim-telescope/telescope-smart-history.nvim",
				build = function()
					local db_subdir = vim.fn.stdpath("data") .. "/databases"
					vim.system({ "mkdir", "-p", db_subdir })
					vim.system({ "touch", db_subdir .. "/telescope_history.sqlite3" })
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"kkharji/sqlite.lua",
				config = function()
					if vim.fn.has("win32") == 1 then
						vim.g.sqlite_clib_path = "c:/tools/sqlite/sqlite3.dll"
					end
				end,
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
			{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Telescope recent files" },
			{
				"<leader>/",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "Telescope current buffer",
			},
			{ "<leader>ca", vim.lsp.buf.code_action, "Telescope Code action" },
		},
		config = function()
			local telescope = require("telescope")
			-- stylua: ignore
			local file_ignore_patterns =
{"^.*%.7z$","^.*%.aux$","^.*%.avi$","^.*%.bak$","^.*%.bib$","^.*%.class$","^.*%.cls$","^.*%.cmi$","^.*%.cmo$","^.*%.doc$","^.*%.docx$","^.*%.dvi$","^.*%.flac$","^.*%.flv$","^.*%.gem$","^.*%.gif$","^.*%.hi$","^.*%.ico$","^.*%.jpeg$","^.*%.jpg$","^.*%.log$","^.*%.min.*%.js$","^.*%.min%.js$","^.*%.mov$","^.*%.mp3$","^.*%.mp4$","^.*%.mpg$","^.*%.nav$","^.*%.o$","^.*%.obj$","^.*%.ods$","^.*%.odt$","^.*%.ogg$","^.*%.opus$","^.*%.out$","^.*%.pdf$","^.*%.pem$","^.*%.png$","^.*%.rar$","^.*%.rbc$","^.*%.rbo$","^.*%.settings$","^.*%.sty$","^.*%.svg$","^.*%.swp$","^.*%.swp.*%.$","^.*%.tar$","^.*%.tar%.bz2$","^.*%.tar%.gz$","^.*%.tar%.xz$","^.*%.tgz$","^.*%.toc$","^.*%.wav$","^.*%.webm$","^.*%.xcf$","^.*%.xls$","^.*%.xlsx$","^.*%.zip$","^.*/%.bundle/.*$","^.*/%.sass%-cache/.*$","^.*/vendor/cache/.*$","^.*/vendor/gems/.*$","^.*%~$","^%._.*$","^%.git$","^%.hg$","^%.svn$","^Thumbs%.db$","^Zend$","^intermediate/.*$","^publish/.*$","^vendor$"}
			telescope.setup({
				defaults = {
					file_ignore_patterns = file_ignore_patterns,
					history = {
						path = vim.fn.stdpath("data") .. "/databases/telescope_history.sqlite3",
						limit = 100,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("smart_history")
			telescope.load_extension("ui-select")
		end,
	},

	-- auto detect indentation
	{
		"Darazaki/indent-o-matic",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = true,
	},

	-- auto locate last location in the file
	{
		"ethanholz/nvim-lastplace",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		config = true,
	},

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},

	{
		"rktjmp/highlight-current-n.nvim",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
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

	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		version = false,
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
				},
			}
		end,
		config = true,
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		opts = {
			{
				enable_rename = true,
				enable_close = true,
				enable_close_on_slash = true,
				filetypes = {
					"html",
					"htmldjango",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"tsx",
					"jsx",
					"rescript",
					"xml",
					"php",
					"markdown",
					"astro",
					"glimmer",
					"handlebars",
					"hbs",
				},
			},
		},
	},
}
