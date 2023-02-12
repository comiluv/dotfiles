-- press F5 to cd to directory, javac %
vim.keymap.set("n", "<F5>", ":<C-u>cd %:p:h<Cr>:<C-u>w<bar>te javac %<CR>", { buffer = true })
vim.keymap.set({ "i", "v" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })

-- press F8 to cd to directory, java %<
vim.keymap.set("n", "<F8>", ":<C-u>cd %:p:h<Cr>:<C-u>w<bar>te java %<<CR>", { buffer = true })
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })

