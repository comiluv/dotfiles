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

	-- Use Microsoft Visual Studio as default C/C++ compiler in Neovim
	{
		"hattya/vcvars.vim",
		event = "VeryLazy",
		config = function()
			-- refernce: https://stackoverflow.com/questions/14369032/how-do-i-set-up-vim-to-compile-using-visual-studio-2010s-c-compiler
			vim.cmd([[
			let vcvars_dict = vcvars#get(vcvars#list()[-1])
			let $PATH = join(vcvars_dict.path, ';') .. ';' .. $PATH
			let $INCLUDE = join(vcvars_dict.include, ';') .. ';' .. $INCLUDE
			let $LIB = join(vcvars_dict.lib, ';') .. ';' .. $LIB
			let $LIBPATH = join(vcvars_dict.libpath, ';') .. ';' .. $LIBPATH
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
		event = { "CmdlineEnter", "BufEnter", "BufNewFile" },
		cmd = { "Subvert", "S", "Abolish" },
		dependencies = { "smjonas/live-command.nvim" },
		config = function()
			require("which-key").register({
				cr = {
					name = "+coercion",
					s = { desc = "snake_case" },
					_ = { desc = "snake_case" },
					m = { desc = "MixedCase" },
					p = { desc = "PascalCase" },
					c = { desc = "camelCase" },
					u = { desc = "SNAKE_UPPER_CASE" },
					U = { desc = "SNAKE_UPPER_CASE" },
					k = { desc = "kebab-case" },
					t = { desc = "Title Case (not reversible)" },
					["-"] = { desc = "kebab-case (not reversible)" },
					["."] = { desc = "dot.case (not reversible)" },
					["<space>"] = { desc = "space case (not reversible)" },
				},
			})
		end,
	},
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
