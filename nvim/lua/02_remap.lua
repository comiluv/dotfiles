vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw" })

-- Don't use Ex mode, use Q for formatting.
-- Revert with ":unmap Q".
vim.keymap.set({ "n", "v" }, "Q", "gq", { remap = true })

-- n N J are centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Easy window navigation
vim.keymap.set("", "<A-h>", "<C-w>h")
vim.keymap.set("", "<A-j>", "<C-w>j")
vim.keymap.set("", "<A-k>", "<C-w>k")
vim.keymap.set("", "<A-l>", "<C-w>l")

-- Left and right can run buffers
vim.keymap.set("n", "<left>", vim.cmd.bprevious)
vim.keymap.set("n", "<right>", vim.cmd.bnext)

-- Conveniently move lines up and down with shift+j and shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Open new file adjacent to current file
-- also see http://vimcasts.org/episodes/the-edit-command/ for verbose version
-- note below is taken from book Practical Vim 2nd edition
local function expand_to_path()
	return vim.fn.getcmdtype() == ":" and vim.fn.expand("%:h") .. "/" or "%%"
end
vim.keymap.set("c", "%%", expand_to_path, { expr = true, desc = "expand to path" })
vim.keymap.set({ "n", "v" }, "<leader>e", "<Esc>:e %%", { remap = true, desc = "Open adjacent file" })

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

-- lsp format placeholder
vim.keymap.set("n", "<leader>f", "<nop>")

-- quickfix navigation
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [q]uickfix list" })
vim.keymap.set("n", "<C-j>", ":cnext<CR>zz")
vim.keymap.set("n", "<C-k>", ":cprev<CR>zz")
vim.keymap.set("n", "<leader>j", ":lnext<CR>zz", { desc = "Next Location" })
vim.keymap.set("n", "<leader>k", ":lprev<CR>zz", { desc = "Previous Location" })

-- replace whatever was on the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace cursor" })

-- replace visually selected
vim.keymap.set("v", "<leader>s", [["ly:%s/\<<C-r>l\>/<C-r>l/gI<Left><Left><Left>]], { desc = "Replace selected" })

-- Press <ESC> to escape insert mode in terminal
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

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

-- open help about the word under cursor by pressing <F1>
vim.keymap.set({ "n", "i", "v", "c" }, "<F1>", "<esc>:help <C-r><C-w><cr>", { silent = true })

-- "around document" text object
vim.keymap.set("o", "ad", "<cmd>normal! ggVG<cr>", { noremap = true, desc = "around document" })
vim.keymap.set("x", "ad", "gg0oG$", { noremap = true, desc = "around document" })

-- Auto-fix typo in command mode: Don't try to be perfect, adjust your tool to
-- help you not the other way around. : https://thoughtbot.com/upcase/vim
-- Bind :Q to q
vim.cmd([[command! Q q]])
vim.cmd([[command! Qall qall]])
vim.cmd([[command! QA qall]])

-- Toggle LSP Diagnostic
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }))
end, { silent = true, noremap = true, desc = "[T]oggle LSP [d]iagnostic" })

-- Move normally in word-wrapped lines
vim.keymap.set("n", "j", function()
	local count = vim.v.count
	if count == 0 then
		return "gj"
	else
		return "j"
	end
end, { expr = true })
vim.keymap.set("n", "k", function()
	local count = vim.v.count
	if count == 0 then
		return "gk"
	else
		return "k"
	end
end, { expr = true })

-- Duplicate current line while staying in the column
vim.keymap.set("n", "<C-,>", function()
	local startofline = vim.opt.startofline:get()
	vim.opt.startofline = false
	vim.cmd.copy(".")
	vim.opt.startofline = startofline
end, { noremap = true })

-- Set language (Human language) for current buffer
-- press z= to get spelling suggestions
vim.keymap.set("n", "<leader>sl", function()
	vim.opt_local.spelllang = vim.fn.input({
		prompt = "Language > ",
		default = vim.bo.spelllang,
		cancelreturn = vim.bo.spelllang,
	})
end, { desc = "[S]et [l]anguage for buffer" })
