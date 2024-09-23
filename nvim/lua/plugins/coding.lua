return {
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			-- tabout required to register tab key remap
			"abecodes/tabout.nvim",
			"onsails/lspkind.nvim",
		},
		opts = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_select_page = { behavior = cmp.SelectBehavior.Select, count = 8 }
			local luasnip = require("luasnip")
			local neogen = require("neogen")
			local copilot = require("copilot.suggestion")
			return {
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-u>"] = cmp.mapping.select_prev_item(cmp_select_page),
					["<C-d>"] = cmp.mapping.select_next_item(cmp_select_page),
					["<up>"] = cmp.mapping.select_prev_item(cmp_select),
					["<down>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ select = true }),
					}),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping.complete(),
					-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item(cmp_select)
							else
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
							end
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif neogen.jumpable() then
							neogen.jump_next()
						elseif copilot.is_visible() then
							copilot.accept()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item(cmp_select)
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						elseif neogen.jumpable(true) then
							neogen.jump_prev()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}),
				experimental = {
					ghost_text = false,
				},
			}
		end,
		config = function(_, opts)
			local lspkind = require("lspkind")
			local cmp = require("cmp")
			opts.formatting = {
				format = lspkind.cmp_format({}),
			}
			cmp.setup(opts)
			cmp.event:on("menu_opened", function()
				vim.b.copilot_suggestion_hidden = true
			end)
			cmp.event:on("menu_closed", function()
				local luasnip = require("luasnip")
				if not (luasnip.jumpable(1) or luasnip.jumpable(-1)) then
					vim.b.copilot_suggestion_hidden = false
				end
			end)
			cmp.setup.filetype({ "lua" }, {
				sources = cmp.config.sources({
					{ name = "nvim_lua" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
			cmp.setup.filetype({ "rust" }, {
				sources = cmp.config.sources({
					{ name = "crates" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}),
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
		-- jsregexp setup see https://github.com/L3MON4D3/LuaSnip/issues/1190#issuecomment-2171656749
		build = vim.fn.executable("make") == 1 and "make install_jsregexp"
			or (vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1)
				and ("pwsh -NoProfile " .. vim.fn.stdpath("config") .. "/luasnip_jsregexp_build.ps1"),
	},

	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
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
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
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
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		version = false,
		config = true,
	},

	-- tab out from parentheses, quotes, similar contexts
	{
		"abecodes/tabout.nvim",
		event = "InsertCharPre",
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
