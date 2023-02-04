-- it'll also be used for C++

-- make a keymap for F5 to invoke make on the file
vim.keymap.set("n", "<F5>", ":<C-u>w!<bar>!make %<<CR>", { buffer = true })

-- pressing F5 key in insert mode or visual mode will exit respective mode
-- and press F5 in normal mode
vim.keymap.set({ "i", "v" }, "<F5>", "<ESC><F5>", { remap = true })

-- pressing f8 will invoke command :<C-u>term ./%<CR>
if vim.fn.has("macunix") == true then
	vim.keymap.set("n", "<f8>", ":<C-u>term ./%<CR>", { buffer = true })
else
	vim.keymap.set("n", "<f8>", ":<C-u>term %<.exe<CR>", { buffer = true })
end

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { remap = true })
