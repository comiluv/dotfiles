--[[
List of plugins that Neovim version is desired
{
	www.github.com/mbbill/undotree         : Lua could be faster
                                           : http://github.com/debugloop/telescope-undo.nvim but not equivalent
	www.github.com/tpope/vim-abolish       : No preview, lua could be faster
                                           : https://github.com/smjonas/live-command.nvim doesn't work due to https://github.com/smjonas/live-command.nvim/issues/24
                                           : https://github.com/johmsalas/text-case.nvim is buggy
	www.github.com/andymass/vim-matchup    : lua could be faster
	www.github.com/Exafunction/codeium.vim : lua could be faster
                                           : there is https://github.com/jcdickinson/codeium.nvim but Windows is not supported
	www.github.com/pbrisbin/vim-mkdir      : lua could be faster
	www.github.com/junegunn/vim-easy-align : lua could be faster
}
]]--
local OpenedBuffer = { "BufRead", "BufNewFile", } -- note new buffer opened by :enew
                                                  -- doesn't trigger neighther of the events

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", "<CMD>Telescope find_files<Cr>", desc = "Find files" },
			{ "<C-p>",      "<CMD>Telescope git_files<Cr>",  desc = "Find git files" },
			{ "<leader>ps", "<CMD>Telescope live_grep<Cr>",  desc = "Live grep" },
		},
		config = function()
			require("telescope").setup({})
			require("telescope").load_extension("fzf")
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		cmd = "TSUpdate",
		event = OpenedBuffer,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the four listed parsers should always be installed)
				ensure_installed = { "help", "c", "lua" },
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				-- List of parsers to ignore installing (for "all")
				ignore_install = {},
				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					-- disable = { "c", "rust" },
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					-- disable = function(lang, buf)
					--     local max_filesize = 100 * 1024 -- 100 KB
					--     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					--     if ok and stats and stats.size > max_filesize then
					--         return true
					--     end
					-- end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				endwise = { enable = true }, -- "RRethy/nvim-treesitter-endwise",
				autotag = { enable = true }, -- "windwp/nvim-ts-autotag",
				markid = { enable = true }, -- "David-Kunz/markid",
				matchup = { enable = true }, -- "andymass/vim-matchup",
			})
		end,
		dependencies = {
			-- semantic highlighting
			"David-Kunz/markid",
			-- auto close block with end
			"RRethy/nvim-treesitter-endwise",
			-- auto clost tags
			"windwp/nvim-ts-autotag",
		},
	},

	-- auto close parentheses
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			-- use tree-sitter for nvim-autopairs
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			npairs.setup({
				check_ts = true,
				ts_config = {},
				enable_check_bracket_line = false,
				fast_wrap = {},
			})

			local ts_conds = require("nvim-autopairs.ts-conds")

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

			-- auto addspace on =
			npairs.add_rules({
				Rule("=", "", { "-gitattributes", "-sh", "-zsh", "-vim" })
				:with_pair(cond.not_inside_quote())
				:with_pair(function(opts)
					local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
					if last_char:match("[%w%=%s]") then
						return true
					end
					return false
				end)
				:replace_endpair(function(opts)
					local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
					local next_char = opts.line:sub(opts.col, opts.col)
					next_char = next_char == " " and "" or " "
					if prev_2char:match("%w$") then
						return "<bs> =" .. next_char
					end
					if prev_2char:match("%=$") then
						return next_char
					end
					if prev_2char:match("=") then
						return "<bs><bs>=" .. next_char
					end
					return ""
				end)
				:set_end_pair_length(0)
				:with_move(cond.none())
				:with_del(cond.none()),
			})

			-- Expand multiple pairs on enter key
			-- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
			local get_closing_for_line = function(line)
				local i = -1
				local clo = ""

				while true do
					i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
					if i == nil then
						break
					end
					local ch = string.sub(line, i, i)
					local st = string.sub(clo, 1, 1)

					if ch == "{" then
						clo = "}" .. clo
					elseif ch == "}" then
						if st ~= "}" then
							return ""
						end
						clo = string.sub(clo, 2)
					elseif ch == "(" then
						clo = ")" .. clo
					elseif ch == ")" then
						if st ~= ")" then
							return ""
						end
						clo = string.sub(clo, 2)
					elseif ch == "[" then
						clo = "]" .. clo
					elseif ch == "]" then
						if st ~= "]" then
							return ""
						end
						clo = string.sub(clo, 2)
					end
				end

				return clo
			end

			-- npairs.remove_rule('(')
			-- npairs.remove_rule('{')
			-- npairs.remove_rule('[')

			npairs.add_rule(Rule("[%(%{%[]", "")
			:use_regex(true)
			:replace_endpair(function(opts)
				return get_closing_for_line(opts.line)
			end)
			:end_wise(function(opts)
				-- Do not endwise if there is no closing
				return get_closing_for_line(opts.line) ~= ""
			end))

			local cmp = require("cmp")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			-- If you want insert `(` after select function or method item
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- autopairs: add mapping `CR` on nvim-cmp setup. Check readme.md on nvim-cmp repo
			local handlers = require("nvim-autopairs.completion.handlers")

			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					filetypes = {
						-- "*" is a alias to all filetypes
						["*"] = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
								},
								handler = handlers["*"],
							},
						},
						lua = {
							["("] = {
								kind = {
									cmp.lsp.CompletionItemKind.Function,
									cmp.lsp.CompletionItemKind.Method,
								},
								---@param char string
								---@param item table item completion
								---@param bufnr number buffer number
								---@param rules table
								---@param commit_character table<string>
								handler = function(char, item, bufnr, rules, commit_character)
									-- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
								end,
							},
						},
						-- Disable for tex
						tex = false,
					},
				})
			)
		end,
	},

	-- jump to matching parens
	{
		"andymass/vim-matchup",
		event = OpenedBuffer,
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
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
		config = function()
			require("neogen").setup({
				snippet_engine = "luasnip",
			})
		end,
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		event = OpenedBuffer,
		cmd = "Mason",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			-- https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs
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

			local lsp = require("lsp-zero")
			-- Learn the keybindings, see :help lsp-zero-keybindings
			-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
			lsp.preset("recommended")

			lsp.ensure_installed({
				"lua_ls",
			})

			-- Fix Undefined global 'vim'
			lsp.configure("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			lsp.configure("grammarly", {
				filetypes = { "markdown", "text" },
			})

			-- Have to do this or lsp-zero won't let nvim-jdtls handle jdtls
			lsp.skip_server_setup({ "jdtls" })

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- https://github.com/windwp/nvim-autopairs
				["<C-e>"] = cmp.mapping.abort(),
				["<C-Space>"] = cmp.mapping.complete(),
			})

			-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
			local luasnip = require("luasnip")
			cmp_mappings["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" })
			cmp_mappings["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable( -1) then
					luasnip.jump( -1)
				else
					fallback()
				end
			end, { "i", "s" })

			-- fix lsp-zero auto selecting first item: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/advance-usage.md#dont-preselect-first-match
			lsp.setup_nvim_cmp({
				preselect = cmp.PreselectMode.None,
				mapping = cmp_mappings,
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
			})

			lsp.set_preferences({
				suggest_lsp_servers = true,
				sign_icons = {
					error = "✘",
					warn = "▲",
					hint = "⚑",
					info = "",
				},
			})

			lsp.on_attach(function(client, bufnr)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
				vim.keymap.set(
					"n",
					"gr",
					require("telescope.builtin").lsp_references,
					{ buffer = bufnr, desc = "Go to references" }
				)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
				vim.keymap.set(
					"n",
					"<leader>vws",
					vim.lsp.buf.workspace_symbol,
					{ buffer = bufnr, desc = "Workspace symbol" }
				)
				vim.keymap.set(
					"n",
					"<leader>vd",
					vim.diagnostic.open_float,
					{ buffer = bufnr, desc = "View diagnostic" }
				)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
				vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
				vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = bufnr, desc = "Open references" })
				vim.keymap.set("n", "<leader>vrn", ":IncRename <C-r><C-w>", { buffer = bufnr, desc = "Rename symbol" })
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
				vim.keymap.set(
					"n",
					"<space>wa",
					vim.lsp.buf.add_workspace_folder,
					{ buffer = bufnr, desc = "Workspace Add folder" }
				)
				vim.keymap.set(
					"n",
					"<space>wr",
					vim.lsp.buf.remove_workspace_folder,
					{ buffer = bufnr, desc = "Worksapce Remove folder" }
				)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, { buffer = bufnr, desc = "Workspace List folders" })

				-- get nvim-navic working with multiple tabs
				if client.server_capabilities["documentSymbolProvider"] then
					require("nvim-navic").attach(client, bufnr)
				end
			end)

			lsp.setup()

			vim.diagnostic.config({
				virtual_text = false,
			})
		end,
	},

	-- java language server because lsp-zero (and lspconfig to extent) doesn't work
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
	},

	-- AI completion
	{
		"Exafunction/codeium.vim",
		lazy = false,	-- lazy loading broke tab completion and fallback
		cmd = "Codeium",
		event = "InsertEnter",
		config = function()
			vim.g.codeium_enabled = false
		end,
	},

	-- debug adapater protocol
	{
		"mfussenegger/nvim-dap",
		event = OpenedBuffer,
	},

	-- inject LSP diagnostics, code actions, formatting etc.
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = OpenedBuffer,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local sources = {
				-- python
				require("null-ls").builtins.formatting.black.with({
					extra_args = { "--line-length=120" },
				}),
				require("null-ls").builtins.formatting.isort,
				require("null-ls").builtins.formatting.stylua,
				require("null-ls").builtins.formatting.google_java_format,
			}
			require("null-ls").setup({ sources = sources })
		end,
	},

	-- show lightbulb where code action can be taken
	{
		"kosayoda/nvim-lightbulb",
		event = OpenedBuffer,
		config = function()
			require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
		end,
	},

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		event = OpenedBuffer,
		config = true,
	},

	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", "<cmd>LazyGit<cr>", silent = true, desc = [[Open LazyGit (A-\ is ESC)]] },
		},
	},

	{
		"kylechui/nvim-surround",
		event = OpenedBuffer,
		version = "*",
		config = true,
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Open Undotree" },
		},
	},

	-- automatically create any non-existent directories
	{
		"pbrisbin/vim-mkdir",
		event = "BufWritePre",
	},

	-- comment/uncomment hotkeys
	{
		"numToStr/Comment.nvim",
		event = OpenedBuffer,
		config = function()
			require("Comment").setup({
				toggler = {
					block = "gbb",
				},
			})
		end,
	},

	{
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter' },
		cmd = {"TSJToggle", "TSJSplit", "TSJJoin"},
		keys = {
			{ "<leader>m", "<cmd>TSJToggle<Cr>", desc = "Wrap/unwrap arguments" },
		},
		config = function()
			require('treesj').setup({
				use_default_keymaps = false,
			})
		end,
	},

	-- auto locate last location in the file
	{
		"vladdoster/remember.nvim",
		event = OpenedBuffer,
		config = true,
	},

	-- show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = OpenedBuffer,
		config = function()
			-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/539
			require("indent_blankline").setup({
				enabled = true,
				char_blankline = "┆",
				show_current_context = true,
				show_current_context_start = true,
				use_treesitter = false, -- false because treesitter indentation is still buggy in some languages
				use_treesitter_scope = true,
			})
		end,
	},

	-- auto detect indentation
	{
		"Darazaki/indent-o-matic",
		event = OpenedBuffer,
		config = true,
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

	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = OpenedBuffer,
		config = true,
	},

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = OpenedBuffer,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		event = OpenedBuffer,
		config = true,
	},

	-- dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local startify = require("alpha.themes.startify")
			-- Powershell fortune: https://www.bgreco.net/fortune
			-- fortune.txt.dat is produced in WSL
			--[[ local handle
				if vim.fn.has('win32') == 1 then
					handle = assert(io.popen("fortune.ps1|cowsay -W 120 --random", "r"))
				else
					handle = assert(io.popen("fortune|cowsay -W 120 --random", "r"))
				end
				local fortune_raw = assert(handle:read("*a"))
				handle:close()

				local fortune = {}
				for s in string.gmatch(fortune_raw, "[^\r\n]+") do
					table.insert(fortune, s)
				end

				startify.section.header.val = fortune ]]
			alpha.setup(startify.config)
		end,
	},

	-- history
	{
		"gaborvecsei/memento.nvim",
		lazy = false,
		keys = {
			{
				"<leader>ho",
				function()
					require("memento").toggle()
				end,
				desc = "Open history",
			},
			{
				"<leader>hc",
				function()
					require("memento").clear()
				end,
				desc = "Clear history",
			},
		},
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			vim.g.memento_shorten_path = false
		end,
	},

	-- winbar plugin
	{
		"utilyre/barbecue.nvim",
		event = OpenedBuffer,
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function()
			require("barbecue").setup({
				create_autocmd = false,
				attach_navic = false,
			})

			local events = {
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
			}

			if vim.fn.has("nvim-0.9") == 1 then
				table.insert(events, "WinResized")
			end

			vim.api.nvim_create_autocmd(events, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = OpenedBuffer,
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	-- case preserving replace with :%S command, case-rename-snakecase commands
	{
		"tpope/vim-abolish",
		cmd = "S",
	},

	-- colorschemes
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require("onedark").setup({
				highlights = {
					IndentBlanklineContextChar = { fg = "$light_grey", fmt = "nocombine" },
					IndentBlanklineContextStart = { sp = "$light_grey", fmt = "nocombine,underline" },
				},
			})
			require("onedark").load()
		end,
	},
	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = true,
		config = function()
			require("NeoSolarized").setup({
				transparent = false,
			})
		end,
	},
	{
		"tanvirtin/monokai.nvim",
		lazy = true,
	},
	{
		"luisiacc/gruvbox-baby",
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
}

