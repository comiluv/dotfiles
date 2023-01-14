vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)


-- No arrow keys --- force yourself to use the home row
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")

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

-- Undo breakpoints for C-U and C-W in insert mode
vim.keymap.set("i", "<C-U>", "<C-G>u<C-U>")
vim.keymap.set("i", "<C-W>", "<C-G>u<C-W>")

-- Allow easy navigation between wrapped lines.
-- Merged this to jumplist modification below
--nmap j gj
--nmap k gk
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")

-- Easy window navigation
vim.keymap.set("", "<A-h>", "<C-w>h")
vim.keymap.set("", "<A-j>", "<C-w>j")
vim.keymap.set("", "<A-k>", "<C-w>k")
vim.keymap.set("", "<A-l>", "<C-w>l")

-- Left and right can switch buffers
vim.keymap.set("n", "<left>", ":bp<CR>")
vim.keymap.set("n", "<right>", ":bn<CR>")

-- Conveniently move lines up and down with ctrl+j and ctrl+k
--vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
--vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
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
vim.keymap.set("x", "<leader>p", [["_dP"]])

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Open new file adjacent to current file
-- also see http://vimcasts.org/episodes/the-edit-command/ for verbose version
-- also note below is taken from book Practical Vim 2nd edition which should be
-- update of this remap
vim.keymap.set("c", "%%", function()
    return vim.fn.getcmdtype() == ':' and vim.fn.expand("%:h") .. "/" or "%%"
end, { expr = true })
vim.keymap.set("", "<leader>e", ":e %%", { remap = true })

-- Prevent common mistake of pressing q: instead :q
vim.keymap.set("", "q:", ":q")

-- Allow for easy copying and pasting
vim.keymap.set("v", "y", "y`]", { silent = true })
vim.keymap.set("n", "p", "p`]", { silent = true })
vim.keymap.set("n", "P", "P`]", { silent = true })

-- Visually select the text that was last edited/pasted (Vimcast#26).
vim.keymap.set("", "gV", "`[v`]")

-- Auto-fix typo in command mode: Don't try to be perfect, adjust your tool to
-- help you not the other way around. : https://thoughtbot.com/upcase/vim
-- Bind :Q to q
vim.cmd([[command! Q q]])
vim.cmd([[command! Qall qall]])
vim.cmd([[command! QA qall]])

-- Easy Ctrl-C to Esc insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable 'press :qa to exit' messages
vim.keymap.set("n", "<C-c>", "<C-c>", { silent = true })

-- Use <C-L> to clear the highlighting of :set hlsearch.
vim.keymap.set("n", "<C-L>", ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>", { silent = true })

-- fix & command Practical Vim tip 93
vim.keymap.set("n", "&", ":&&<CR>")
vim.keymap.set("x", "&", ":&&<CR>")

-- lsp format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace whatever was on the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
