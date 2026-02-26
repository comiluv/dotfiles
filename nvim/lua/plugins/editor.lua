return {
	-- comment/uncomment hotkeys
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		opts = { toggler = { block = "gbb" } },
	},

	{
		"folke/ts-comments.nvim",
		lazy = true,
		opts = {},
	},

	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		version = "*",
		opts = {},
	},

	-- auto close parentheses
	{
		"windwp/nvim-autopairs",
		cond = false,
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")

			-- Press <A-e> in insert mode for fast wrap
			npairs.setup({
				fast_wrap = {},
			})
		end,
	},

	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recommended as each new version will have breaking changes
		opts = {
			--Config goes here
		},
	},

	-- tab out from parentheses, quotes, similar contexts
	{
		"abecodes/tabout.nvim",
		event = "InsertCharPre",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			tabkey = "",
			backwards_tabkey = "",
			completion = false,
		},
	},

	{
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		version = false,
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = require("utils").ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			local utils = require("utils")
			utils.on_load("which-key.nvim", function()
				vim.schedule(function()
					utils.ai_whichkey(opts)
				end)
			end)
		end,
	},

	-- easy align comments
	{
		"nvim-mini/mini.align",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		version = false,
		opts = {},
	},

	-- Quickly change keyword case (Coerce)
	{
		"gregorias/coerce.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile" },
		dependencies = { "folke/which-key.nvim" },
		opts = {
			default_mode_mask = { visual_mode = false },
		},
	},

	-- abbreviations and substitutions
	{
		"tpope/vim-abolish",
		event = { "CmdlineEnter", "VeryLazy", "BufNewFile" },
		cmd = { "Subvert", "S", "Abolish" },
		init = function()
			-- Disable coercion mappings. I use coerce.nvim for that.
			vim.g.abolish_no_mappings = true
		end,
	},

	-- jump to matching parens
	{
		"andymass/vim-matchup",
		lazy = true,
		init = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},

	-- wrap/unwrap arguments
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		keys = {
			{ "<leader>m", vim.cmd.TSJToggle, desc = "Wrap/unwrap arguments" },
		},
		opts = { use_default_keymaps = false, max_join_length = 0xffffff },
	},

	-- auto generate comments on a hotkey
	{
		"danymat/neogen",
		version = "*",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
		keys = {
			{
				"<leader>gc",
				function()
					require("neogen").generate()
				end,
				silent = true,
				desc = "Generate comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- show invisible characters in visual mode
	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged *:[vV\22]",
		opts = {},
	},

	{
		"jiaoshijie/undotree",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
}
