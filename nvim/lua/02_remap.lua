vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw" })

-- Don't use Ex mode, use Q for formatting.
-- Revert with ":unmap Q".
vim.keymap.set("", "Q", "gq", { remap = true })

-- n N J are centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Undo breakpoints
vim.keymap.set("i", ",", ",<C-G>u")
vim.keymap.set("i", ".", ".<C-G>u")
vim.keymap.set("i", "!", "!<C-G>u")
vim.keymap.set("i", "?", "?<C-G>u")

-- Easy window navigation
vim.keymap.set("", "<A-h>", "<C-w>h")
vim.keymap.set("", "<A-j>", "<C-w>j")
vim.keymap.set("", "<A-k>", "<C-w>k")
vim.keymap.set("", "<A-l>", "<C-w>l")

-- Left and right can switch buffers
vim.keymap.set("n", "<left>", "<cmd>bp<CR>")
vim.keymap.set("n", "<right>", "<cmd>bn<CR>")

-- Conveniently move lines up and down with ctrl+j and ctrl+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Use <Tab> and <S-Tab> to navigate through popup menu and <Enter> to select
vim.keymap.set("i", "<Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

-- delete selection and put without yanking selection
vim.keymap.set("x", "<leader>p", [["_dP"]], { desc = "Delete selection" })

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to clipboard" })

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole" })

-- Open new file adjacent to current file
-- also see http://vimcasts.org/episodes/the-edit-command/ for verbose version
-- also note below is taken from book Practical Vim 2nd edition which should be
-- update of this remap
vim.keymap.set("c", "%%", function()
	return vim.fn.getcmdtype() == ":" and vim.fn.expand("%:h") .. "/" or "%%"
end, { expr = true })
vim.keymap.set("n", "<leader>e", ":e %%", { remap = true, desc = "Open adjacent file" })
vim.keymap.set("v", "<leader>e", "<Esc>:e %%", { remap = true, desc = "Open adjacent file" })

-- prevent common mistake of pressing q: instead of :q
vim.keymap.set("n", "q:", ":q")

-- Allow for easy copying and pasting
vim.keymap.set("v", "y", "y`]", { silent = true })
vim.keymap.set("n", "p", "p`]", { silent = true })
vim.keymap.set("n", "P", "P`]", { silent = true })

-- Visually select the text that was last edited/pasted (Vimcast#26).
vim.keymap.set("n", "gV", "`[v`]")

-- Easy Ctrl-C to Esc insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable 'press :qa to exit' messages
vim.keymap.set("n", "<C-c>", "<Esc>")

-- lsp format
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true, timeout_ms = 10000 }) end,
	{ desc = "Format buffer" })

-- quickfix navigation
vim.keymap.set("n", "<C-j>", ":cnext<CR>zz")
vim.keymap.set("n", "<C-k>", ":cprev<CR>zz")
vim.keymap.set("n", "<leader>j", ":lnext<CR>zz", { desc = "Next Location" })
vim.keymap.set("n", "<leader>k", ":lprev<CR>zz", { desc = "Previous Location" })

-- replace whatever was on the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cursor" })

-- Neovim terminal mode remaps
-- Use Escape key like a sane person
vim.keymap.set("t", [[<A-\>]], [[<C-\><C-n>]])

-- Move out from terminal window with alt key shortcuts
vim.keymap.set("t", "<A-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<A-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<A-l>", [[<C-\><C-n><C-w>l]])

-- Switch between the last two files
vim.keymap.set("n", "<Leader><Leader>", "<C-^>", { desc = "Switch buffer" })

-- Remap !:cmd to terminal cmd
vim.keymap.set("c", "!", function()
	return vim.fn.getcmdtype() == ":" and (vim.fn.getcmdpos() == 1 and "terminal " or "!") or "!"
end, { expr = true })

-- open help about the word on cursor by pressing <F1>
vim.keymap.set("n", "<F1>", ":help <C-r><C-w><CR>", { silent = true })
vim.keymap.set({ "c", "i", "v" }, "<F1>", "<ESC><F1>", { silent = true, remap = true })

-- "around document" text object
vim.keymap.set("o", "ad", "<CMD>normal! ggVG<CR>", { noremap = true, desc = "around document" })
vim.keymap.set("x", "ad", "gg0oG$", { noremap = true, desc = "around document" })

-- Auto-fix typo in command mode: Don't try to be perfect, adjust your tool to
-- help you not the other way around. : https://thoughtbot.com/upcase/vim
-- Bind :Q to q
vim.cmd([[command! Q q]])
vim.cmd([[command! Qall qall]])
vim.cmd([[command! QA qall]])

