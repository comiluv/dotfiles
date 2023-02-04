-- pressing f8 will invoke command :<C-u>w!<bar>term py %<CR>
vim.keymap.set("n", "<f8>", ":<C-u>w!<bar>term py %<CR>", { buffer = true })

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { remap = true })
