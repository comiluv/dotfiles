return {
	{
		"navarasu/onedark.nvim",
	},
	{
		"NTBBloodbath/doom-one.nvim",
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
	},
	{
		"p00f/alabaster.nvim",
		priority = 1000,
		config = function()
			vim.opt.background = "light"
			vim.cmd.colorscheme("alabaster")
		end,
	},
	{
		"miikanissi/modus-themes.nvim",
	},
	{
		"polirritmico/monokai-nightasty.nvim",
	},
	{
		"thimc/gruber-darker.nvim",
	},
}
