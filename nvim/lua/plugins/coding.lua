return {
	-- Autocompletion
	-- Requires manual git command in https://github.com/ms-jpq/coq_nvim/issues/589#issuecomment-1651436348
	{
		"ms-jpq/coq_nvim",
		lazy = true,
		dependencies = {
			-- add vscode-like pictograms
			"onsails/lspkind.nvim",
			"zbirenbaum/copilot.lua",
		},
		init = function()
			vim.g.coq_settings = {
				auto_start = true,
				keymap = { recommended = false },
			}
			-- Keybindings
			local has_copilot, copilot = pcall(require, "copilot.suggestion")
			local has_tabout, _ = pcall(require, "tabout")

			local map = function(lh, rh, mode)
				mode = mode or "i"
				vim.keymap.set(mode, lh, rh, { expr = true, silent = true })
			end

			local termcode = function(key)
				return vim.api.nvim_replace_termcodes(key, true, true, false)
			end

			local tab_key = function()
				if vim.fn.pumvisible() ~= 0 then
					if vim.fn.complete_info().selected == -1 then
						return termcode("<C-n>")
					else
						return termcode("<C-y>")
					end
				elseif has_copilot and copilot.is_visible() then
					copilot.accept()
				elseif has_tabout then
					return termcode("<Plug>(TaboutMulti)")
				else
					return termcode("<Tab>")
				end
			end

			local shift_tab_key = function()
				if vim.fn.pumvisible() ~= 0 then
					return termcode("<C-p>")
				elseif has_tabout then
					return termcode("<Plug>(TaboutBackMulti)")
				else
					return termcode("<S-Tab>")
				end
			end

			local cr_key = function()
				if vim.fn.pumvisible() ~= 0 then
					if vim.fn.complete_info({ "selected" }).selected ~= -1 then
						return termcode("<c-y>")
					else
						print("nothing selected")
						return termcode("<c-e>") .. termcode("<cr>")
					end
				else
					return termcode("<cr>")
				end
			end

			local bs_key = function()
				if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
					return termcode("<c-e>") .. termcode("<bs>")
				else
					return termcode("<bs>")
				end
			end

			map("<Esc>", [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]])
			map("<C-c>", [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]])
			vim.keymap.set(
				"i",
				"<C-d>",
				[[pumvisible() ? "\<C-n><C-n><C-n><C-n><C-n><C-n><C-n><C-n>" : "\<C-d>"]],
				{ noremap = false, silent = true, expr = true }
			)
			vim.keymap.set(
				"i",
				"<C-u>",
				[[pumvisible() ? "\<C-p><C-p><C-p><C-p><C-p><C-p><C-p><C-p>" : "\<C-u>"]],
				{ noremap = false, silent = true, expr = true }
			)

			map("<BS>", bs_key)
			map("<CR>", cr_key)
			map("<Tab>", tab_key)
			map("<S-Tab>", shift_tab_key)
		end,
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
				map_cr = false,
				map_bs = false,
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
		dependencies = { "nvim-treesitter/nvim-treesitter", "zbirenbaum/copilot.lua" },
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
