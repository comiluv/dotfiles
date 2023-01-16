local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup('MyGroup', {})

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

-- Trim Whitespace
autocmd({ "BufWritePre" }, {
    group = MyGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Remove autocommenting when pressing o or O on a commented line
autocmd({ "FileType" }, {
    group = MyGroup,
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove { "r", "o" }
    end,
})

-- quit help pressing just q without : to enter command mode
autocmd({ "FileType" }, {
    group = MyGroup,
    pattern = "help",
    callback = function()
        vim.keymap.set("n", "q", ":q<CR>", { buffer = true })
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
