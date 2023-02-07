local ok, memento = pcall(require, "memento")
if not ok then return end

vim.keymap.set("n", "<leader>ho", function() memento.toggle() end, {desc = "Open history"})
vim.keymap.set("n", "<leader>hc", function() memento.clear() end, {desc = "Clear history"})

vim.g.memento_shorten_path = false

