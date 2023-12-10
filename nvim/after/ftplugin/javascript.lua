-- As suggested by prettier
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- pressing f8 will run the file and skip vim.fn.has("node") test for performance
vim.keymap.set("n", "<F8>", ":<C-u>update<BAR>:cd %:p:h<BAR>:exec 'term node' shellescape(@%)<CR>", { buffer = true })

-- pressing F8 in insert mode or visual mode will exit respective mode and press F8
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
