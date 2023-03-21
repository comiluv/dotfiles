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
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
		config = function()
			require("chatgpt").setup({
				-- setups
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}

