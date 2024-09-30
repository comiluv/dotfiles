vim.bo.tabstop = 8
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

local has_runhaskell = vim.fn.executable("runhaskell") == 1
local has_runghc = vim.fn.executable("runghc") == 1

if not has_runhaskell and not has_runghc then
	vim.api.nvim_command('echomsg "runhaskell not found"')
	do
		return
	end
end

local haskell = has_runhaskell and "runhaskell" or "runghc"

-- pressing f8 will run the file
vim.keymap.set("n", "<F5>", ":<C-u>update<BAR>:cd %:p:h<BAR>:exec '!ghc' shellescape(@%)<CR>", { buffer = true })
vim.keymap.set(
	"n",
	"<F8>",
	":<C-u>update<BAR>:cd %:p:h<BAR>:exec '!" .. haskell .. "' shellescape(@%)<CR>",
	{ buffer = true }
)

-- pressing keymap in insert mode or visual mode will exit respective mode and run normal mode version
vim.keymap.set({ "i", "x" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })
