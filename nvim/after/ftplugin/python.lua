if not vim.fn.has('python3') then
    vim.api.nvim_command('echomsg "python3 not found"')
    do return end
end
-- pressing f8 will run the file
local py = "python3"
if vim.fn.has("win32") then
    py = "python"
end

-- if I find out how to send output to terminal using :pyfile, will switch to the version below
vim.keymap.set("n", "<F8>", ":<C-u>w!<CR>:exec 'term "..py.."' shellescape(@%)<CR>", { buffer = true })
-- vim.keymap.set("n", "<F8>", ":<C-u>w!<CR>:pyfile %<CR>", { buffer = true })

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { remap = true })
