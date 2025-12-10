return {
	{
		"yetone/avante.nvim",
		version = false, -- set this if you want to always pull the latest change
		cmd = { "AvanteAsk" },
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "AI: Avante Sidebar" },
		},
		opts = {
			provider = "claude",
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") == 1
				and "pwsh -NoProfile -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
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
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
		cond = function()
			return vim.fn.executable("node") == 1
		end,
		config = function()
			-- https://codeinthehole.com/tips/vim-and-github-copilot/
			local copilot_enabled_filetypes = {
				gitcommit = true,
				markdown = true,
				yaml = true,
			}
			local filetypes = require("utils").array_to_table(vim.g.info_filetype, false)
			for k, v in pairs(copilot_enabled_filetypes) do
				filetypes[k] = v
			end
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<Tab>",
					},
				},
				filetypes = filetypes,
			})
			-- detach Copilot for big files
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("CopilotFileSizeCheck", {}),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.name == "copilot" then
						local file_size = vim.fn.getfsize(args.file)
						if file_size > 100 * 1024 or file_size == -2 then -- 100 KB
							vim.defer_fn(function()
								vim.cmd.Copilot("detach")
							end, 0)
						end
					end
				end,
			})
			-- start Copilot disabled
			vim.cmd.Copilot("enable")
		end,
	},

	-- AI assisted LSP diagnostics
	{
		"piersolenski/wtf.nvim",
		event = { "LspAttach" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim", -- Optional: For WtfGrepHistory
		},
		keys = {
			{
				"<leader>wa",
				mode = { "n", "x" },
				function()
					require("wtf").ai()
				end,
				desc = "AI: Debug diagnostic with AI",
			},
			{
				mode = { "n" },
				"<leader>ws",
				function()
					require("wtf").search()
				end,
				desc = "AI: Search diagnostic with Google",
			},
			{
				mode = { "n" },
				"<leader>wh",
				function()
					require("wtf").history()
				end,
				desc = "AI: Populate the quickfix list with previous chat history",
			},
			{
				mode = { "n" },
				"<leader>wg",
				function()
					require("wtf").grep_history()
				end,
				desc = "AI: Grep previous chat history with Telescope",
			},
		},
		config = function()
			require("wtf").setup({
				provider = "openai",
				providers = {
					ollama = {
						model_id = "gpt-oss:20b",
					},
				},
			})
		end,
	},
}
