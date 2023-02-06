local betterTerm = require("betterTerm")
-- toggle firts term
vim.keymap.set({ "n", "t" }, "<leader>`", betterTerm.open, { desc = "Open terminal" })
-- Select term focus
vim.keymap.set({ "n", "t" }, "<leader>tt", betterTerm.select, { desc = "Select terminal" })
-- Create new term
local current = 2
vim.keymap.set({ "n", "t" }, "<leader>tn", function()
	betterTerm.open(current)
	current = current + 1
end, { desc = "New terminal" })

-- use the best keymap for you
-- change 1 for other terminal id
-- Change "get_filetype_command()" to "get_project_command().command" for running projects
vim.keymap.set("n", "<leader>r", function()
	require("betterTerm").send(require("code_runner.commands").get_filetype_command(), 1, false)
end, { desc = "Excute File" })
