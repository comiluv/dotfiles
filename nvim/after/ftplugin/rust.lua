if vim.fn.exists(":RustLsp") == 0 then
	vim.notify("Rustaceanvim Not Found", vim.log.levels.WARN)
	return
end

vim.keymap.set("n", "<f8>", function()
	vim.cmd.cd("%:p:h")
	vim.cmd.RustLsp({ "runnables", bang = true })
end, { buffer = true })

vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
