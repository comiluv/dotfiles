return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<Tab>",
					},
				},
				filetypes = {
					qf = false,
					notify = false,
					lspinfo = false,
					spectre_panel = false,
					startuptime = false,
					tsplayground = false,
					PlenaryTestPopup = false,
					fugitive = false,
					checkhealth = false,
					memento = false,
					tsplaground = false,
				},
			})
			vim.cmd("Copilot disable")
		end,
	},
	-- Packer
	{
		-- see https://github.com/microsoft/terminal/issues/530#issuecomment-755917602
		-- https://zshchun.github.io/posts/windows-terminal-wsl2-%EC%97%90%EC%84%9C-shift-enter-%EC%9E%85%EB%A0%A5%EB%B0%A9%EB%B2%95/
		-- https://en.wikipedia.org/wiki/ANSI_escape_code
		-- to use C-Enter in Windows Terminal
		"comiluv/ChatGPT.nvim",
		cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
		config = function()
			require("chatgpt").setup({ })
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}

