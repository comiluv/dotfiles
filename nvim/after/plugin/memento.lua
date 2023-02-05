vim.g.memento_shorten_path = false
vim.keymap.set("n", "<leader>ho", function() require("memento").toggle() end)
vim.keymap.set("n", "<leader>hc", function() require("memento").clear_history() end)
