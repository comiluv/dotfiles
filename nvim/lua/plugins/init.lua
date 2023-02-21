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
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},

	{ "nvim-treesitter/nvim-treesitter" },

	-- semantic highlighting
	"David-Kunz/markid",

	-- auto close parentheses
	"windwp/nvim-autopairs",

	-- auto close block with end
	"RRethy/nvim-treesitter-endwise",

	-- auto clost tags
	"windwp/nvim-ts-autotag",

	-- jump to matching parens
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},

	-- auto generate comments on a hotkey
	{
		"danymat/neogen",
		version = "*",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("neogen").setup({
				snippet_engine = "luasnip"
			})
			vim.keymap.set("n", "<leader>gc", function() require("neogen").generate() end, {desc = "Generate comment", silent = true})
		end,
	},

	{
		"VonHeikemen/lsp-zero.nvim",
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
	},

	-- java language server because lsp-zero (and lspconfig to extent) doesn't work
	'mfussenegger/nvim-jdtls',

	-- AI completion
	{
		"Exafunction/codeium.vim",
		config = function()
			vim.g.codeium_enabled = false
		end,
	},

	-- debug adapater protocol
	"mfussenegger/nvim-dap",

	-- inject LSP diagnostics, code actions, formatting etc.
	{ "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- show lightbulb where code action can be taken
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
		end,
	},

	-- LSP incrementally rename symbol
	{
		"smjonas/inc-rename.nvim",
		config = true,
	},

	"kdheepak/lazygit.nvim",

	{
		"kylechui/nvim-surround",
		version = "*",
		config = true,
	},

	"mbbill/undotree",

	-- automatically create any non-existent directories
	"pbrisbin/vim-mkdir",

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					block = 'gbb',
				},
			})
		end,
	},

	-- auto locate last location in the file
	{
		"vladdoster/remember.nvim",
		config = true,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/539
			require("indent_blankline").setup({
				enabled = true,
				char_blankline = '┆',
				show_current_context = true,
				show_current_context_start = true,
				use_treesitter = false,	-- false because treesitter indentation is still buggy in some languages
				use_treesitter_scope = true,
			})
		end,
	},

	{
		'Darazaki/indent-o-matic',
		config = true,
	},

	-- easy align comments
	{
		"junegunn/vim-easy-align",
		config = function()
			vim.keymap.set({"x", "n"}, "ga", "<Plug>(EasyAlign)")
			vim.g.easy_align_delimiters = { ["/"]= { pattern= "//\\+", delimiter_align= "l", ignore_groups= "!Comment" } }
		end
	},

	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		config = true,
	},

	-- dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- history
	{ "gaborvecsei/memento.nvim", dependencies = "nvim-lua/plenary.nvim" },

	-- winbar plugin
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			create_autocmd = false,
			attach_navic = false,
		},
	},

	{
		"folke/which-key.nvim",
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
	"tpope/vim-abolish",

	-- colorschemes
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				highlights = {
					IndentBlanklineContextChar = { fg = "$light_grey", fmt = "nocombine" },
					IndentBlanklineContextStart = { sp = "$light_grey", fmt = "nocombine,underline" },
				}
			})
			require("onedark").load()
		end,
	},
	{
		"svrana/neosolarized.nvim",
		dependencies = { "tjdevries/colorbuddy.nvim" },
		lazy = true,
		config = function()
			require("neosolarized").setup({
				comment_italics = true,
				background_set = true,
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

