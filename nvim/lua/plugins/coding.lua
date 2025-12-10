return {
	-- Completion
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		version = "1.*",
		event = "InsertEnter",
		-- build = "cargo build --release",
		opts = {
			keymap = {
				preset = "super-tab",
				["C-y"] = { "select_and_accept" },
				["<CR>"] = { "accept", "fallback" },
				["<C-d>"] = {
					function(cmp)
						cmp.select_next({ count = 8 })
					end,
				},
				["<C-u>"] = {
					function(cmp)
						cmp.select_prev({ count = 8 })
					end,
				},
			},
			snippets = { preset = "luasnip" },
			completion = {
				accept = { auto_brackets = { enabled = true } },
				list = { selection = { preselect = false } },
				documentation = { auto_show = true },
				ghost_text = { enabled = false },
			},
			cmdline = { enabled = false },
		},
		init = function()
			local BlinkGroup = vim.api.nvim_create_augroup("BlinkCmpCopilotGroup", {})
			vim.api.nvim_create_autocmd("User", {
				group = BlinkGroup,
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					local has_copilot, copilot = pcall(require, "copilot.suggestion")
					if has_copilot then
						copilot.dismiss()
						vim.b.copilot_suggestion_hidden = true
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = BlinkGroup,
				pattern = "BlinkCmpMenuClose",
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
		end,
	},

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = {
			-- Snippet Collection (Optional)
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function(_, opts)
			require("luasnip").config.setup({
				ext_opts = {
					[require("luasnip.util.types").choiceNode] = {
						active = {
							virt_text = { { "●", "GruvboxOrange" } },
						},
					},
					[require("luasnip.util.types").insertNode] = {
						active = {
							virt_text = { { "●", "GruvboxBlue" } },
						},
					},
				},
			})
			require("luasnip").setup(opts)
			local luasnip_group = vim.api.nvim_create_augroup("LuaSnipCopilotGroup", {})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LuasnipInsertNodeEnter",
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = true
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LuasnipInsertNodeLeave",
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
			vim.api.nvim_create_autocmd("InsertLeave", {
				group = luasnip_group,
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
		end,
		build = "make install_jsregexp",
	},

	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		version = "*",
		opts = {},
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

			-- Press <A-e> in insert mode for fast wrap
			npairs.setup({
				fast_wrap = {},
			})
		end,
	},

	-- comment/uncomment hotkeys
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
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
		"echasnovski/mini.align",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		version = false,
		opts = {},
	},

	-- tab out from parentheses, quotes, similar contexts
	{
		"abecodes/tabout.nvim",
		event = "InsertCharPre",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"zbirenbaum/copilot.lua",
		},
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
