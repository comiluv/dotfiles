return {
	{
		"yetone/avante.nvim",
		version = false, -- set this if you want to always pull the latest change
		cmd = { "AvanteAsk" },
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "AI: Avante Sidebar" },
		},
		config = function(_, opts)
			local settings = {
				mode = "legacy",
				provider = "openrouter-gpt",
				providers = {
					ollama = {
						endpoint = "http://localhost:11434",
						model = "codestral:latest",
						timeout = 30000,
						disable_tools = true,
						is_env_set = require("avante.providers.ollama").check_endpoint_alive,
					},
					["openrouter-gpt"] = {
						__inherited_from = "openai",
						endpoint = "https://openrouter.ai/api/v1",
						model = "mistralai/devstral-2512:free",
						api_key_name = "OPENROUTER_API_KEY",
						timeout = 30000,
						disable_tools = true,
					},
				},
				behaviour = {
					auto_approve_tool_permissions = false,
				},
				selector = {
					provider = "telescope",
				},
				input = {
					provider = "snacks",
					provier_opts = {
						title = "Avante Input",
						icon = " ",
					},
				},
			}
			require("avante").setup(settings)
		end,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") == 1
				and "pwsh -NoProfile -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim",
			{
				"folke/snacks.nvim",
				lazy = false,
				priority = 1000,
				opts = {},
			},
			"nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
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
					restart_highlighter = true,
				},
				ft = { "markdown", "Avante" },
			},
		},
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
			})
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
		cond = vim.g.llm == "copilot" and vim.fn.executable("node") == 1,
		config = function()
			-- https://codeinthehole.com/tips/vim-and-github-copilot/
			local copilot_enabled_filetypes = {
				"gitcommit",
				"markdown",
				"yaml",
			}
			local filetypes = require("utils").array_to_table(vim.g.info_filetype, false)
			for _, v in ipairs(copilot_enabled_filetypes) do
				filetypes[v] = true
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
		end,
		init = function()
			-- detach Copilot for big files
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("CopilotFileSizeCheck", {}),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.name == "copilot" then
						local file_size = vim.fn.getfsize(args.file)
						if file_size > 100 * 1024 or file_size == -2 then -- 100 KB
							vim.defer_fn(function()
								vim.cmd("Copilot detach")
							end, 0)
						end
					end
				end,
			})
		end,
	},

	{
		"milanglacier/minuet-ai.nvim",
		cond = vim.g.llm == "minuet",
		event = "InsertEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			virtualtext = {
				auto_trigger_ft = { "*" },
				auto_trigger_ignore_ft = vim.g.info_filetype,
				keymap = {
					-- accept whole completion
					accept = "<Tab>",
					-- accept one line
					accept_line = "<A-a>",
					-- accept n lines (prompts for number)
					-- e.g. "A-z 2 CR" will accept 2 lines
					accept_n_lines = "<A-z>",
					-- Cycle to prev completion item, or manually invoke completion
					prev = "<A-[>",
					-- Cycle to next completion item, or manually invoke completion
					next = "<A-]>",
					dismiss = "<C-]>",
				},
			},
			provider = "codestral",
			provider_options = {
				codestral = {
					optional = {
						max_tokens = 256,
						stop = { "\n\n" },
					},
				},
			},
			presets = {
				preset_1 = {
					provider = "openai_fim_compatible",
					request_timeout = 10,
					n_completions = 1,
					context_window = 2048,
					provider_options = {
						openai_fim_compatible = {
							name = "ollama",
							end_point = "http://localhost:11434/v1/completions",
							api_key = vim.fn.has("win32") and "APPDATA" or "TERM",
							stream = true,
							model = "freehuntx/qwen3-coder:30b",
							optional = {
								max_tokens = nil,
								top_p = 0.9,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("minuet").setup(opts)
			-- detach Minuet for big files
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("MinuetFileSizeCheck", {}),
				callback = function(args)
					local file_size = vim.fn.getfsize(args.file)
					if file_size > 100 * 1024 or file_size == -2 then -- 100 KB
						vim.defer_fn(function()
							vim.cmd("Minuet virtualtext disable")
						end, 0)
					else
						vim.defer_fn(function()
							vim.cmd("Minuet virtualtext enable")
						end, 0)
					end
				end,
			})
		end,
	},
}
