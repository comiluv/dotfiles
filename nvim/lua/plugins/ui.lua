return {
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		keys = {
			{ "<leader>gs", "<cmd>LazyGit<cr>", silent = true, desc = [[Open LazyGit (A-\ is ESC)]] },
		},
	},

	-- show indent lines
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufRead", "BufNewFile" },
		opts = {
			enabled = true,
			filetype_exclude = {
				"help",
				"alpha",
				"dashboard",
				"lazy",
				"Trouble",
				"memento-menu",
			},
			char_blankline = "┆",
			show_current_context = true,
			show_current_context_start = true,
			use_treesitter = false, -- false because treesitter indentation is still buggy in some languages
			use_treesitter_scope = true,
		},
	},

	-- statusline written in lua
	{
		"nvim-lualine/lualine.nvim",
		event = { "BufRead", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},

	-- dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local startify = require("alpha.themes.startify")
			-- Powershell fortune: https://www.bgreco.net/fortune
			-- fortune.txt.dat is produced in WSL
			--[[ local handle
				if vim.fn.has('win32') == 1 then
					handle = assert(io.popen("fortune.ps1|cowsay -W 120 --random", "r"))
				else
					handle = assert(io.popen("fortune|cowsay -W 120 --random", "r"))
				end
				local fortune_raw = assert(handle:read("*a"))
				handle:close()

				local fortune = {}
				for s in string.gmatch(fortune_raw, "[^\r\n]+") do
					table.insert(fortune, s)
				end

				startify.section.header.val = fortune ]]
			alpha.setup(startify.config)
		end,
	},

	-- history
	{
		"gaborvecsei/memento.nvim",
		event = "VimEnter",	-- lazy=true or "VeryLazy" didn't work
		keys = {
			{
				"<leader>ho",
				function()
					require("memento").toggle()
				end,
				desc = "Open history",
			},
			{
				"<leader>hc",
				function()
					require("memento").clear_history()
				end,
				desc = "Clear history",
			},
		},
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			vim.g.memento_shorten_path = false
		end,
	},

	-- winbar plugin
	{
		"utilyre/barbecue.nvim",
		event = { "BufRead", "BufNewFile" },
		name = "barbecue",
		version = "*",
		opts = {
			create_autocmd = false,
			attach_navic = false,
		},
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = function(_, opts)
			require("barbecue").setup(opts)

			local events = {
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
			}

			if vim.fn.has("nvim-0.9") == 1 then
				table.insert(events, "WinResized")
			end

			vim.api.nvim_create_autocmd(events, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},

	-- LSP progress
	{
		"j-hui/fidget.nvim",
		event = { "BufRead", "BufNewFile" },
		config = true,
	},

	-- show lightbulb where code action can be taken
	{
		"kosayoda/nvim-lightbulb",
		event = { "BufRead", "BufNewFile" },
		opts = {
			autocmd = { enabled = true },
		},
	},
}

