return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.0",
		-- or                            , branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},

	{ "nvim-treesitter/nvim-treesitter" },

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
			{ "hrsh7th/cmp-path" },
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

	-- semantic highlighting
	"David-Kunz/markid",

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
		config = function()
			require("inc_rename").setup()
		end,
	},

	"kdheepak/lazygit.nvim",

	"tpope/vim-surround",

	-- auto close parentheses
	"windwp/nvim-autopairs",

	-- auto close block with end
	"RRethy/nvim-treesitter-endwise",

	-- auto clost tags
	"windwp/nvim-ts-autotag",

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
		config = function()
			require("remember")
		end,
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

	-- display git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
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

	-- colorschemes
	{
		"navarasu/onedark.nvim",
		lazy = true,
		config = function()
			require("onedark").setup({
				highlights = {
					IndentBlanklineContextChar = { fg = "$light_grey", fmt = "nocombine" },
					IndentBlanklineContextStart = { sp = "$light_grey", fmt = "nocombine,underline" },
				}
			})
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

