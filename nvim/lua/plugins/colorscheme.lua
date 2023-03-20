return {
	{
		"navarasu/onedark.nvim",
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
		lazy = true,
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
		end
	},
}

