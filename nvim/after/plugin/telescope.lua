local ok, telescope = pcall(require,'telescope')
if not ok then return end
local builtin = require'telescope.builtin'

vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = "Find files"})
vim.keymap.set('n', '<C-p>', builtin.git_files, {}, {desc = "Find git files"})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, {desc = "Grep string"})

telescope.setup{}
telescope.load_extension('fzf')

