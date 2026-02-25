return {
	-- Open the current word with custom openers, GitHub shorthands for example.
	{
		"ofirgall/open.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
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

	{
		-- support for image pasting
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			-- recommended settings
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = {
					insert_mode = true,
				},
				-- required for Windows users
				use_absolute_path = true,
			},
		},
	},

	{
		"comiluv/tabdiff.nvim",
		cmd = "Tabdiff",
		opts = {},
	},

	{
		"kkharji/sqlite.lua",
		lazy = true,
		init = function()
			if jit.os == "Windows" then
				vim.g.sqlite_clib_path = "c:/tools/sqlite/sqlite3.dll"
			end
		end,
	},

	-- setup environmental variables for Visual Studio compiler
	{
		"hattya/vcvars.vim",
		ft = { "c", "cpp", "cs" },
		cond = jit.os == "Windows",
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

	-- Extends zip.vim to browse and edit nested zip files
	{
		"lbrayner/vim-rzip",
		event = { "VeryLazy" },
		init = function()
			vim.g.rzipPlugin_extra_ext = "*.pak"
		end,
	},
}
