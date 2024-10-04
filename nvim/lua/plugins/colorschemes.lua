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
	},
	{
		"miikanissi/modus-themes.nvim",
	},
	{
		"polirritmico/monokai-nightasty.nvim",
	},
	{
		"thimc/gruber-darker.nvim",
		priority = 1000,
		config = function()
			require("gruber-darker").setup()
			vim.cmd.colorscheme("gruber-darker")
			vim.opt.background = "dark"
		end,
	},
}
