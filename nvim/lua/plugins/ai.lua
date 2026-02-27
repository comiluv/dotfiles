return {
	{
		"yetone/avante.nvim",
		version = false, -- set this if you want to always pull the latest change
		cond = false,
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
		build = jit.os == "Windows"
				and "pwsh -NoProfile -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
			"HakonHarnes/img-clip.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
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
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		cmd = "Copilot",
		build = ":Copilot auth",
		cond = vim.env.NEOVIM_COMPLETION_LLM == "copilot" and vim.fn.executable("node") == 1,
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
						accept = false,
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
						local stat = vim.uv.fs_stat(args.file)
						if not stat or stat.type == "directory" or stat.size > 102400 then
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
		cond = vim.env.NEOVIM_COMPLETION_LLM == "minuet",
		event = { "BufReadPre", "BufAdd", "BufNewFile", "InsertEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			notify = false,
			virtualtext = {
				auto_trigger_ft = { "*" },
				auto_trigger_ignore_ft = vim.g.info_filetype,
				keymap = {
					-- accept whole completion
					accept = nil,
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
			-- request_timeout = 60,
			n_completions = 1,
			-- context_window = 768,
			provider_options = {
				openai_fim_compatible = {
					name = "ollama",
					end_point = "http://localhost:11434/v1/completions",
					api_key = jit.os == "Windows" and "APPDATA" or "TERM",
					stream = false,
					model = "deepseek-coder-v2:16b",
					optional = {
						max_tokens = 56,
						top_p = 0.9,
					},
				},
			},
			presets = {
				preset_1 = {
					provider = "openai_fim_compatible",
					request_timeout = 30,
					n_completions = 1,
					context_window = 768,
					provider_options = {
						openai_fim_compatible = {
							name = "ollama",
							end_point = "http://localhost:11434/v1/completions",
							api_key = jit.os == "Windows" and "APPDATA" or "TERM",
							stream = false,
							model = "freehuntx/qwen3-coder:30b",
							optional = {
								max_tokens = 56,
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
					local stat = vim.uv.fs_stat(args.file)
					if not stat or stat.type == "directory" or stat.size > 102400 then
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

	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
			"Davidyz/VectorCode",
		},
		version = "^18.0.0",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
		opts = function()
			local opts = {
				extensions = {
					history = {
						enabled = true,
						opts = {
							dir_to_save = vim.g.stdpath_data .. "/codecompanion_chats",
						},
					},
					vectorcode = {
						enabled = true,
					},
				},
				interactions = {
					chat = {
						adapter = {
							name = "openai",
							model = "gpt-5.2",
						},
						keymaps = {
							close = {
								modes = { n = "q" },
							},
							stop = {
								modes = { n = "Q" },
							},
						},
					},
				},
			}
			return opts
		end,
	},

	{
		"Davidyz/VectorCode",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		version = "*",
		build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
		opts = {
			-- async_backend = "lsp",
		},
	},
}
