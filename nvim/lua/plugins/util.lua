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

	-- setup environmental variables for Visual Studio compiler
	{
		"hattya/vcvars.vim",
		event = "VeryLazy",
		config = function()
			-- https://stackoverflow.com/questions/14369032/how-do-i-set-up-vim-to-compile-using-visual-studio-2010s-c-compiler
			vim.cmd([[
			if (len(vcvars#list()) > 0)
				let vcvars_dict = vcvars#get(vcvars#list()[-1])
				let $PATH = join(vcvars_dict.path, ';') .. ';' .. $PATH
				let $INCLUDE = join(vcvars_dict.include, ';') .. ';' .. $INCLUDE
				let $LIB = join(vcvars_dict.lib, ';') .. ';' .. $LIB
				let $LIBPATH = join(vcvars_dict.libpath, ';') .. ';' .. $LIBPATH
			endif
			]])
		end,
	},

	-- regex explainer
	{
		"tomiis4/hypersonic.nvim",
		event = "CmdlineEnter",
		cmd = "Hypersonic",
		config = true,
	},

	-- abbreviations and substitutions
	{
		"tpope/vim-abolish",
		event = { "CmdlineEnter", "VeryLazy", "BufNewFile" },
		cmd = { "Subvert", "S", "Abolish" },
		dependencies = { "smjonas/live-command.nvim" },
		config = function()
			require("which-key").add({
				{ "cr", group = "coercion" },
				{ "cr-", desc = "kebab-case (not reversible)" },
				{ "cr.", desc = "dot.case (not reversible)" },
				{ "cr<space>", desc = "space case (not reversible)" },
				{ "crU", desc = "SNAKE_UPPER_CASE" },
				{ "cr_", desc = "snake_case" },
				{ "crc", desc = "camelCase" },
				{ "crk", desc = "kebab-case" },
				{ "crm", desc = "MixedCase" },
				{ "crp", desc = "PascalCase" },
				{ "crs", desc = "snake_case" },
				{ "crt", desc = "Title Case (not reversible)" },
				{ "cru", desc = "SNAKE_UPPER_CASE" },
			})
		end,
	},

	-- see changes in live action
	{
		"smjonas/live-command.nvim",
		version = false,
		event = { "CmdlineEnter" },
		config = function()
			require("live-command").setup({
				Norm = { cmd = "norm" },
				commands = {
					S = { cmd = "Subvert" },
				},
			})
		end,
	},
}
