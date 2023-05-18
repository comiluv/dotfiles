return {
	{
		"kylechui/nvim-surround",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
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
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		opts = { toggler = { block = "gbb" } },
	},

	-- wrap/unwrap arguments
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		keys = {
			{ "<leader>m", vim.cmd.TSJToggle, desc = "Wrap/unwrap arguments" },
		},
		opts = { use_default_keymaps = false, max_join_length = 0xffffff },
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

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		event = { "BufRead", "BufNewFile", "InsertEnter" },
		config = true,
	},

	-- better quickfix list
	{
		"kevinhwang91/nvim-bqf",
		event = "VeryLazy",
		opts = {},
	},

	-- tab out from parentheses, quotes, similar contexts
	{
		"abecodes/tabout.nvim",
		event = "InsertEnter",
		dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp", "zbirenbaum/copilot.lua" },
		config = function()
			require("tabout").setup({
				tabkey = "",
				backwards_tabkey = "",
				completion = false,
			})
			vim.keymap.set("i", "<tab>", require("tabout").taboutMulti, { silent = true })
			vim.keymap.set("i", "<s-tab>", require("tabout").taboutBackMulti, { silent = true })
		end,
	},
}
