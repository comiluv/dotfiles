local ok, builtin = pcall(require,'telescope.builtin')
if not ok then return end

vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = "Find files"})
vim.keymap.set('n', '<C-p>', builtin.git_files, {}, {desc = "Find git files"})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, {desc = "Grep string"})

require'telescope'.setup{}
require'telescope'.load_extension('fzf')

