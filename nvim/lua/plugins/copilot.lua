return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
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
			local filetypes = array_to_table(vim.g.info_file_pattern)
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

	{
		-- to use C-Enter in Windows Terminal:
		-- see https://github.com/microsoft/terminal/issues/530#issuecomment-755917602
		-- https://zshchun.github.io/posts/windows-terminal-wsl2-%EC%97%90%EC%84%9C-shift-enter-%EC%9E%85%EB%A0%A5%EB%B0%A9%EB%B2%95/
		-- https://en.wikipedia.org/wiki/ANSI_escape_code
		"jackMort/ChatGPT.nvim",
		cmd = {
			"ChatGPT",
			"ChatGPTActAs",
			"ChatGPTEditWithInstructions",
			"ChatGPTRun",
			"ChatGPTRunCustomCodeAction",
		},
		opts = {
			chat = {
				question_sign = "🙂",
				answer_sign = "🤖",
			},
			openai_params = {
				max_tokens = 2000,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
