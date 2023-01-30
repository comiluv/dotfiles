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

	"numToStr/Comment.nvim",

	{ "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons"}, lazy = true },

	"navarasu/onedark.nvim",

	{ "vladdoster/remember.nvim", config = [[ require('remember') ]] },
}
