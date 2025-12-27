return {
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
		ft = { "c", "cpp" },
		cond = vim.fn.has("win32") == 1,
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

	-- abbreviations and substitutions
	{
		"tpope/vim-abolish",
		event = { "CmdlineEnter", "VeryLazy", "BufNewFile" },
		cmd = { "Subvert", "S", "Abolish" },
		init = function()
			-- Disable coercion mappings. I use coerce.nvim for that.
			vim.g.abolish_no_mappings = true
		end,
	},

	-- Quickly change keyword case (Coerce)
	{
		"gregorias/coerce.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile" },
		dependencies = {
			"folke/which-key.nvim",
		},
		opts = {
			default_mode_mask = { visual_mode = false },
		},
	},

	-- Extends zip.vim to browse and edit nested zip files
	{
		"lbrayner/vim-rzip",
		event = { "VeryLazy" },
		init = function()
			vim.g.rzipPlugin_extra_ext = "*.pak"
		end,
	},
}
