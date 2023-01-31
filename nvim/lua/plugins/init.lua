return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.0",
		-- or                            , branch = '0.1.x',
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
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

	{ "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	"mbbill/undotree",

	"tpope/vim-fugitive",

	"tpope/vim-surround",

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{ "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons" }, lazy = true },

	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember")
		end,
	},

	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},

	{ "lukas-reineke/indent-blankline.nvim" },

	"windwp/nvim-autopairs",

	"RRethy/nvim-treesitter-endwise",

	"windwp/nvim-ts-autotag",

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- colorschemes
	{
		"tjdevries/colorbuddy.nvim",
		lazy = false,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
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
		"tamelion/neovim-molokai",
		lazy = true,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},
}
