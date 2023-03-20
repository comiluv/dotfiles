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
		},
	},
}

