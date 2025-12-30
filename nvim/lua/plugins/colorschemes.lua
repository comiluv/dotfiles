return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		priority = 1000,
		config = function()
			vim.opt.background = "light"
			vim.cmd.colorscheme("github_light")
		end,
	},
}
