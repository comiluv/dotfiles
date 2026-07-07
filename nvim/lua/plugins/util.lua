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
		lazy = true,
		config = function()
			-- https://stackoverflow.com/questions/14369032/how-do-i-set-up-vim-to-compile-using-visual-studio-2010s-c-compiler
			local list = vim.fn["vcvars#list"]()
			if #list > 0 then
				local vcvars_dict = vim.fn["vcvars#get"](list[#list])
				if vcvars_dict.path and #vcvars_dict.path > 0 then
					vim.env.PATH = table.concat(vcvars_dict.path, ";") .. ";" .. vim.env.PATH
				end
				if vcvars_dict.include and #vcvars_dict.include > 0 then
					vim.env.INCLUDE = table.concat(vcvars_dict.include, ";") .. ";" .. (vim.env.INCLUDE or "")
				end
				if vcvars_dict.lib and #vcvars_dict.lib > 0 then
					vim.env.LIB = table.concat(vcvars_dict.lib, ";") .. ";" .. (vim.env.LIB or "")
				end
				if vcvars_dict.libpath and #vcvars_dict.libpath > 0 then
					vim.env.LIBPATH = table.concat(vcvars_dict.libpath, ";") .. ";" .. (vim.env.LIBPATH or "")
				end
			end
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
