return {
	{
		"yetone/avante.nvim",
		lazy = true,
		version = false, -- set this if you want to always pull the latest change
		cmd = { "AvanteAsk" },
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", "Avante Sidebar" },
		},
		opts = {
			provide = "claude",
			claude = { api_key_name = { "gpg", "-d", vim.fn.getenv("HOME") .. "/anthropic.txt.gpg" } },
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") == 1
				and "pwsh -NoProfile -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		cond = function()
			return vim.fn.executable("gpg") == 1
				and (vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 or vim.fn.executable("make") == 1)
		end,
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
			local function array_to_table(arr)
				local tbl = {}
				for _, v in ipairs(arr) do
					tbl[v] = false
				end
				return tbl
			end
			-- https://codeinthehole.com/tips/vim-and-github-copilot/
			local copilot_enabled_filetypes = {
				gitcommit = true,
				markdown = true,
				yaml = true,
			}
			local filetypes = array_to_table(vim.g.info_filetype)
			for k, v in pairs(copilot_enabled_filetypes) do
				filetypes[k] = v
			end
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = false,
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
						if file_size > 100000 or file_size == -2 then
							vim.defer_fn(function()
								vim.cmd.Copilot("detach")
							end, 0)
						end
					end
				end,
			})
			-- start Copilot disabled
			vim.cmd.Copilot("disable")
		end,
	},

	-- AI assisted LSP diagnostics
	{
		"piersolenski/wtf.nvim",
		event = { "LspAttach" },
		dependencies = {
			"MunifTanjim/nui.nvim",
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
		cond = function()
			return vim.fn.executable("gpg") == 1
		end,
		config = function()
			local on_exit = function(obj)
				local pos = string.find(obj.stdout, "\n")
				local key = string.sub(obj.stdout, 1, pos):gsub("%s+$", "")
				require("wtf").setup({
					openai_model_id = "gpt-4o-mini",
					openai_api_key = key,
				})
			end
			vim.system({ "gpg", "-d", vim.fn.getenv("HOME") .. "/openai.txt.gpg" }, { text = true }, on_exit)
		end,
	},
}
