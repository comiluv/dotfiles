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
		priority = 1000,
		config = function()
			vim.opt.background = "light"
			vim.cmd.colorscheme("github_light")
		end,
	},
	{
		"p00f/alabaster.nvim",
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
