-- stylua
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = false

if vim.fn.executable("lua") == 0 then
	vim.notify("Lua Not Found", vim.log.levels.WARN)
	return
end

-- pressing f8 will run the file
vim.keymap.set("n", "<F8>", ":<C-u>update<BAR>:cd %:p:h<BAR>:exec 'term lua' shellescape(@%)<CR>", { buffer = true })
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
