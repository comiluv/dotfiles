return {
	-- Completion
	{
		"saghen/blink.cmp",
		dependencies = {
			"abecodes/tabout.nvim",
			"L3MON4D3/LuaSnip",
			vim.g.llm == "minuet" and "milanglacier/minuet-ai.nvim" or "zbirenbaum/copilot.lua",
			{
				"onsails/lspkind.nvim",
				opts = {
					preset = "codicons",
					symbol_map = {
						copilot = "",
						claude = "󰋦",
						openai = "󱢆",
						codestral = "󱎥",
						gemini = "",
						groq = "",
						openrouter = "󱂇",
						ollama = "󰳆",
						["llama.cpp"] = "󰳆",
						deepseek = "",
					},
				},
			},
		},
		version = "1.*",
		event = "InsertEnter",
		config = function()
			local llm = nil
			if vim.g.llm == "copilot" then
				llm = require("copilot.suggestion")
			elseif vim.g.llm == "minuet" then
				llm = require("minuet.virtualtext").action
			end
			local opts = {
				keymap = {
					preset = "super-tab",
					["<Tab>"] = {
						function(cmp)
							if cmp.snippet_active() then
								return cmp.accept()
							else
								return cmp.select_and_accept()
							end
						end,
						"snippet_forward",
						function(_)
							if llm.is_visible() then
								return llm.accept()
							end
							return vim.api.nvim_replace_termcodes("<Plug>(TaboutMulti)", true, true, true)
						end,
					},
					["<C-y>"] = { "select_and_accept" },
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
					-- Manually invoke minuet completion.
					["<A-y>"] = vim.g.llm == "minuet" and require("minuet").make_blink_map() or false,
				},
				snippets = { preset = "luasnip" },
				completion = {
					accept = { auto_brackets = { enabled = true } },
					list = { selection = { preselect = false, auto_insert = false } },
					documentation = { auto_show = true },
					ghost_text = { enabled = false },
					trigger = { prefetch_on_insert = false },
					menu = {
						draw = {
							components = {
								kind_icon = {
									ellipsis = false,
									text = function(ctx)
										return require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
									end,
								},
							},
						},
					},
				},
				cmdline = { enabled = false },
			}
			if vim.g.llm == "minuet" then
				opts.sources = {
					default = { "lsp", "path", "buffer", "snippets", "minuet" },
					providers = {
						minuet = {
							name = "minuet",
							module = "minuet.blink",
							async = true,
							-- Should match minuet.config.request_timeout * 1000,
							-- since minuet.config.request_timeout is in seconds
							timeout_ms = 10000,
							score_offset = 50, -- Gives minuet higher priority among suggestions
						},
					},
				}
			end
			if vim.g.llm == "copilot" then
				local BlinkGroup = vim.api.nvim_create_augroup("BlinkCmpCopilotGroup", {})
				vim.api.nvim_create_autocmd("User", {
					group = BlinkGroup,
					pattern = "BlinkCmpMenuOpen",
					callback = function()
						llm.dismiss()
						vim.b.copilot_suggestion_hidden = true
					end,
				})
				vim.api.nvim_create_autocmd("User", {
					group = BlinkGroup,
					pattern = "BlinkCmpMenuClose",
					callback = function()
						vim.b.copilot_suggestion_hidden = false
					end,
				})
			end
			require("blink.cmp").setup(opts)
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
		end,
		init = function()
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
		"nvim-mini/mini.align",
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
		},
		opts = {
			tabkey = "",
			backwards_tabkey = "",
			completion = false,
		},
	},
}
