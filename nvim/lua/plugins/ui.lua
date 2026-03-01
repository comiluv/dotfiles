return {

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufAdd", "BufNewFile" },
		main = "ibl",
		config = function()
			local opts = {
				exclude = { filetypes = vim.g.info_filetype },
				indent = { char = "┆" },
			}
			require("ibl").setup(opts)
			vim.api.nvim_create_autocmd({ "BufAdd", "BufReadPre" }, {
				group = vim.api.nvim_create_augroup("IndentBlankLineGroup", {}),
				callback = function(event)
					if vim.b.indent_blankline_set or event.file == "" then
						return
					end
					vim.b.indent_blankline_set = true
					local stat = vim.uv.fs_stat(event.file)
					if not stat or stat.type == "directory" or stat.size > 1024 * 1024 then
						require("ibl").setup_buffer(event.buf, { scope = { enabled = false } })
						return
					end
				end,
			})
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css", "json" },
		opts = {
			filetypes = { "css", "json" },
			user_default_options = { mode = "virtualtext", names = false, css = true },
		},
	},

	{
		-- Make sure to set this up properly if you have lazy=true
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "codecompanion" },
			restart_highlighter = true,
		},
		ft = { "markdown", "codecompanion" },
	},

	{
		"folke/which-key.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		opts = { delay = 0 },
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	-- Improved UI and workflow for the Neovim quickfix
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
	},
}
