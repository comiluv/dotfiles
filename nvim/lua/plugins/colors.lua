return {
	{
		"navarasu/onedark.nvim",
	},
	{
		"NTBBloodbath/doom-one.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("doom-one")
		end,
	},
}
