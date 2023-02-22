return {
	{
		"navarasu/onedark.nvim",
		opts = {
			highlights = {
				IndentBlanklineContextChar = { fg = "$light_grey", fmt = "nocombine" },
				IndentBlanklineContextStart = { sp = "$light_grey", fmt = "nocombine,underline" },
			},
		},
		config = function(_, opts)
			require("onedark").setup(opts)
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
}

