return {
	-- Autocompletion
	-- Requires manual git command in https://github.com/ms-jpq/coq_nvim/issues/589#issuecomment-1651436348
	{
		"ms-jpq/coq_nvim",
		branch = "coq",
		event = { "InsertEnter" },
		cmd = { "COQdeps", "COQnow", "COQhelp", "COQsnips", "COQstats" },
		dependencies = {
			{ "ms-jpq/coq.artifacts", branch = "artifacts" },
			-- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
			-- Need to **configure separately**
			{ "ms-jpq/coq.thirdparty", branch = "3p" },
			-- add vscode-like pictograms
			"onsails/lspkind.nvim",
			"zbirenbaum/copilot.lua",
		},
		init = function()
			vim.g.coq_settings = {
				auto_start = true,
				keymap = { recommended = false },
				display = { statusline = { helo = false } },
			}

			-- Keybindings
			local has_copilot, copilot = pcall(require, "copilot.suggestion")
			local has_tabout, _ = pcall(require, "tabout")

			local map = function(lh, rh, mode)
				mode = mode or "i"
				vim.keymap.set(mode, lh, rh, { expr = true, silent = true })
			end

			-- https://github.com/abecodes/tabout.nvim?tab=readme-ov-file#more-complex-keybindings
			local termcode = function(key)
				return vim.api.nvim_replace_termcodes(key, true, true, false)
			end

			-- Pop up menu item if none selected, select pop up menu item if any selected, Copilot autocompletion, Tabout Plugin Tab, raw Tab
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

			-- Previous pop up menu item, Tabout Plugin Back, raw S-Tab
			local shift_tab_key = function()
				if vim.fn.pumvisible() ~= 0 then
					return termcode("<C-p>")
				elseif has_tabout then
					return termcode("<Plug>(TaboutBackMulti)")
				else
					return termcode("<S-Tab>")
				end
			end

			-- Accept pop up menu item if selected, otherwise close pop up menu and send CR
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

			-- Close pop up menu and send BS
			local bs_key = function()
				if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
					return termcode("<c-e>") .. termcode("<bs>")
				else
					return termcode("<bs>")
				end
			end

			-- Scroll down pop up menu for at most 8 items
			local ctrl_d_key = function()
				if vim.fn.pumvisible ~= 0 then
					local result = ""
					local current_pos = vim.fn.complete_info({ "selected" }).selected
					local num_items = #vim.fn.complete_info({ "items" }).items - 1 -- Convert 1 based index to 0 based index
					local repeats = current_pos + 8 > num_items and num_items - current_pos or 8
					for _ = 1, repeats do
						result = result .. "<C-n>"
					end
					return termcode(result)
				else
					return termcode("<C-d>")
				end
			end

			-- Scroll up pop up menu for at most 8 items
			local ctrl_u_key = function()
				if vim.fn.pumvisible ~= 0 then
					local result = ""
					local current_pos = vim.fn.complete_info({ "selected" }).selected
					local repeats = current_pos < 8 and current_pos or 8
					for _ = 1, repeats do
						result = result .. "<C-p>"
					end
					return termcode(result)
				else
					return termcode("<C-u>")
				end
			end

			-- Close pop up menu and send ESC
			map("<Esc>", [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]])
			-- Close pop up menu and send C-c
			map("<C-c>", [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]])

			map("<C-d>", ctrl_d_key)
			map("<C-u>", ctrl_u_key)

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
