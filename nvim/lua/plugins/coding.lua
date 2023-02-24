return {
	{
		"kylechui/nvim-surround",
		event = { "BufRead", "BufNewFile" },
		version = "*",
		config = true,
	},

	-- auto generate comments on a hotkey
	{
		"danymat/neogen",
		version = "*",
		dependencies = "nvim-treesitter/nvim-treesitter",
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

	-- AI completion
	{
		"Exafunction/codeium.vim",
		event = "VimEnter", -- lazy=true, "VeryLazy" didn't work
		cmd = "Codeium",
		config = function()
			vim.g.codeium_enabled = false
		end,
	},

	-- auto close parentheses
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			-- use tree-sitter for nvim-autopairs
			local Rule = require("nvim-autopairs.rule")

			npairs.setup({
				check_ts = true,
				ts_config = {},
				fast_wrap = {},
			})

			-- Add spaces between parentheses
			local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
			npairs.add_rules({
				Rule(" ", " "):with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({
						brackets[1][1] .. brackets[1][2],
						brackets[2][1] .. brackets[2][2],
						brackets[3][1] .. brackets[3][2],
					}, pair)
				end),
			})
			for _, bracket in pairs(brackets) do
				npairs.add_rules({
					Rule(bracket[1] .. " ", " " .. bracket[2])
						:with_pair(function()
							return false
						end)
						:with_move(function(opts)
							return opts.prev_char:match(".%" .. bracket[2]) ~= nil
						end)
						:use_key(bracket[2]),
				})
			end

			-- If you want insert `(` after select function or method item
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- comment/uncomment hotkeys
	{
		"numToStr/Comment.nvim",
		event = { "BufRead", "BufNewFile" },
		opts = { toggler = { block = "gbb" } },
	},

	-- wrap/unwrap arguments
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		keys = {
			{ "<leader>m", "<cmd>TSJToggle<Cr>", desc = "Wrap/unwrap arguments" },
		},
		opts = { use_default_keymaps = false },
	},

	-- easy align comments
	{
		"junegunn/vim-easy-align",
		cmd = "EasyAlign",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, desc = "Easy Align" },
		},
		config = function()
			vim.g.easy_align_delimiters =
			{ ["/"] = { pattern = "//\\+", delimiter_align = "l", ignore_groups = "!Comment" } }
		end,
	},

	-- search for, substitute, coerce, and abbreviate variants of a word
	{
		"tpope/vim-abolish",
		event = "CursorHold",
		cmd = { "Abolish", "Subvert", "S" },
		config = function()
			require("which-key").register({
				cr = {
					name = "+coercion",
					s = { desc = "snake_case" },
					_ = { desc = "snake_case" },
					m = { desc = "MixedCase" },
					c = { desc = "camelCase" },
					u = { desc = "SNAKE_UPPER_CASE" },
					U = { desc = "SNAKE_UPPER_CASE" },
					k = { desc = "kebab-case" },
					t = { desc = "Title Case (not reversible)" },
					["-"] = { desc = "kebab-case (not reversible)" },
					["."] = { desc = "dot.case (not reversible)" },
					["<space>"] = { desc = "space case (not reversible)" },
				}
			})
		end
	},

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		event = { "BufRead", "BufNewFile" },
		config = true,
	},
}

