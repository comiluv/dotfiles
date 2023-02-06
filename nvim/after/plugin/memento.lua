vim.keymap.set("n", "<leader>ho", function() require "memento".toggle() end, {desc = "Open history"})
vim.keymap.set("n", "<leader>hc", function() require "memento".clear() end, {desc = "Clear history"})

vim.g.memento_shorten_path = false
