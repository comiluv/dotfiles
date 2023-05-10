return {
	{
		"Mofiqul/vscode.nvim",
		config = function()
			require("vscode").setup({
				transparent = false,
			})
			require("vscode").load()
		end,
	},
}
