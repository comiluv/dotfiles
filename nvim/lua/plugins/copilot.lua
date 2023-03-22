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
		"comiluv/ChatGPT.nvim",
		cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
		config = function()
			local submit = vim.fn.has("win32") == 1 and "<C-Enter>" or "<C-\\>"
			require("chatgpt").setup({
				keymaps = {
					submit = submit,
				}
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}

