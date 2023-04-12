return {
	-- automatically create any non-existent directories
	{
		"jghauser/mkdir.nvim",
		event = "VeryLazy", -- "BufWritePre", "FileWritePre", "BufWriteCmd", "BufModifiedSet", didnt work
	},
}
