local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup('MyGroup', {})
local TrimGroup = augroup('TrimGroup', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Remove autocommenting when pressing o or O on a commented line
autocmd({ "FileType" }, {
    group = MyGroup,
    pattern = "*",
    callback = function()
        -- remove auto commenting when pressing <o> or <O> in normal mode
        vim.opt.formatoptions:remove "o"
        -- auto remove comment when joining lines with <J> key
        vim.opt.formatoptions:append "j"
    end,
})

-- close some filetypes with <q>
autocmd({ "FileType" }, {
    group = MyGroup,
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
        "fugitive",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- auto toggle cursorline in insert mode
autocmd({ "InsertLeave", "WinEnter" }, {
    group = MyGroup,
    pattern = "*",
    callback = function()
        vim.opt.cursorline = true
    end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
    group = MyGroup,
    pattern = "*",
    callback = function()
        vim.opt.cursorline = false
    end,
})

-- enter Terminal-mode automatically
autocmd({ "TermOpen" }, {
    group = MyGroup,
    pattern = "*",
    command = "startinsert",
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = MyGroup,
    pattern = "*",
    command = "checktime",
})

-- trim whitespace and put one blank line at the end
-- source 1: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim/7501902#7501902
-- source 2: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
-- source 3: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
autocmd("BufWritePre",{
    group = TrimGroup,
    pattern ="*",
    callback = function()
        local register = vim.fn.getreg('/')
        local save_pos = vim.fn.getpos('.')
        vim.cmd[[keeppatterns keepjumps %s/\s\+$//e]]   -- trim right
        vim.cmd[[keeppatterns keepjumps silent! 0;/^\%(\_s*\S\)\@!/,$d]]   -- trim below
        vim.cmd[[keeppatterns keepjumps $put _]]    -- add one blank line
        vim.fn.setreg('/', register)
        vim.fn.setpos('.', save_pos)
    end
})

