return {
	{
		"Mofiqul/vscode.nvim",
		config = function()
			vim.o.background = "light"
			require("vscode").setup({
				transparent = false,
			})
			require("vscode").load()
		end,
	},
}
