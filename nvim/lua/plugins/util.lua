return {
	-- automatically create any non-existent directories
	{
		"jghauser/mkdir.nvim",
		event = "BufEnter",
		-- event = "VeryLazy", -- "BufWritePre", "FileWritePre", "BufWriteCmd", "BufModifiedSet", didnt work
	},

	-- Open the current word with custom openers, GitHub shorthands for example.
	{
		"ofirgall/open.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			{
				"gx",
				function()
					require("open").open_cword()
				end,
				desc = "Open cursor using system default program",
			},
		},
		opts = { curl_opts = { compressed = false } },
	},
}
