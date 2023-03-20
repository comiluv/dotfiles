return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			panel = {
				enabled = true,
			},
			suggestion = {
				enabled = true,
				auto_trigger = false,
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
			},
		},
	},
}

