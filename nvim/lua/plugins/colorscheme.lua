return {
	{
		"navarasu/onedark.nvim",
		lazy = true,
		config = function()
			require("onedark").setup()
			require("onedark").load()
		end,
	},

	{
		"Tsuzat/NeoSolarized.nvim",
		lazy = true,
		opts = { transparent = false },
	},

	{
		"tanvirtin/monokai.nvim",
		lazy = true,
	},

	{
		"luisiacc/gruvbox-baby",
		config = function()
			vim.cmd.colorscheme("gruvbox-baby")
		end,
	},

	{
		"Mofiqul/dracula.nvim",
		lazy = true,
	},

	{
		"Mofiqul/vscode.nvim",
		lazy = true,
		config = function()
			require("vscode").setup({
				transparent = false,
			})
			require("vscode").load()
		end,
	},
}
