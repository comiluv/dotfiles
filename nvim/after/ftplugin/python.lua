-- As suggested by PEP8
vim.bo.tabstop = 8
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

if vim.fn.has("python3") == 0 then
	vim.api.nvim_command('echomsg "python3 not found"')
	do
		return
	end
end

local py = "python3"
if vim.fn.has("win32") == 1 then
	py = "python"
end

-- pressing f8 will run the file
-- if I find out how to send output to terminal using :pyfile, will switch to the version below
vim.keymap.set(
	"n",
	"<F8>",
	":<C-u>update<BAR>:cd %:p:h<BAR>:exec 'term " .. py .. "' shellescape(@%)<CR>",
	{ buffer = true }
)
-- vim.keymap.set("n", "<F8>", ":<C-u>update<BAR>:cd %:h<BAR>:pyfile %<CR>", { buffer = true })

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
