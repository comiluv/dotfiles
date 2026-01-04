-- As suggested by PEP8
vim.bo.tabstop = 8
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

local py = vim.g.python3_host_prog
if not py then
	vim.notify("Python3 Not Found", vim.log.levels.WARN)
	return
end

-- pressing f8 will run the file
vim.keymap.set(
	"n",
	"<F8>",
	":<C-u>update<BAR>:cd %:p:h<BAR>:exec 'term " .. py .. "' shellescape(@%)<CR>",
	{ buffer = true }
)

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
