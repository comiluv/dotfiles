local get_blink_deps = function()
	local deps = {
		"abecodes/tabout.nvim",
		"L3MON4D3/LuaSnip",
		"onsails/lspkind.nvim",
		"nvim-tree/nvim-web-devicons",
	}
	if vim.g.llm == "minuet" then
		table.insert(deps, "milanglacier/minuet-ai.nvim")
	elseif vim.g.llm == "copilot" then
		table.insert(deps, "zbirenbaum/copilot.lua")
	end
	return deps
end
return {
	-- Completion
	{
		"saghen/blink.cmp",
		dependencies = get_blink_deps(),
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
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
							if llm and llm.is_visible() then
								return llm.accept()
							end
							return vim.api.nvim_replace_termcodes("<Plug>(TaboutMulti)", true, true, true)
						end,
					},
					["<S-Tab>"] = {
						"snippet_backward",
						function(_)
							return vim.api.nvim_replace_termcodes("<Plug>(TaboutBackMulti)", true, true, true)
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
										local icon = ctx.kind_icon
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
											if dev_icon then
												icon = dev_icon
											end
										else
											icon = require("lspkind").symbol_map[ctx.kind] or ""
										end

										return icon .. ctx.icon_gap
									end,

									highlight = function(ctx)
										local hl = ctx.kind_hl
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
											if dev_icon then
												hl = dev_hl
											end
										end
										return hl
									end,
								},
							},
						},
					},
				},
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
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		config = function(_, opts)
			require("luasnip").config.setup({
				ext_opts = {
					[require("luasnip.util.types").choiceNode] = {
						active = {
							virt_text = { { "●", "DiagnosticWarn" } },
						},
					},
					[require("luasnip.util.types").insertNode] = {
						active = {
							virt_text = { { "●", "DiagnosticInfo" } },
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
		"rafamadriz/friendly-snippets",
		lazy = true,
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	{
		"onsails/lspkind.nvim",
		lazy = true,
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
}
