local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup("MyGroup", {})
local TrimGroup = augroup("TrimGroup", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

vim.g.info_file_pattern = {
	"PlenaryTestPopup",
	"Trouble",
	"chatgpt",
	"checkhealth",
	"fugitive",
	"help",
	"lazy",
	"lspinfo",
	"man",
	"memento",
	"netrw",
	"notify",
	"qf",
	"spectre_panel",
	"startuptime",
	"tsplayground",
	"undotree",
	"diff",
	"packer",
	"gitcommit",
	"TelescopePrompt",
	"TelescopeResults",
	"''",
}

local trim_exclusions = {
	"markdown",
}

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove inserting comment marker the cursor is on a comment and open a new line
autocmd({ "FileType" }, {
	group = MyGroup,
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "o" })
		-- auto remove comment when joining lines with <J> key
		vim.opt.formatoptions:append("j")
	end,
})

-- close some filetypes with <q>
autocmd({ "FileType" }, {
	group = MyGroup,
	pattern = vim.g.info_file_pattern,
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>silent! close<cr>", { buffer = event.buf, nowait = true })
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
	command = "checktime",
})

-- trim whitespace and put one blank line at the end
-- source 1: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim/7501902#7501902
-- source 2: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
-- source 3: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
autocmd("BufWritePre", {
	group = TrimGroup,
	pattern = "*",
	callback = function()
		-- Only trim when there's no formatter attached
		if #(require("conform").list_formatters()) > 0 then
			return
		end
		for _, filetype in ipairs(trim_exclusions) do
			if vim.bo.filetype == filetype then
				return
			end
		end
		local register = vim.fn.getreg("/")
		local save_pos = vim.fn.getpos(".")
		vim.cmd([[silent! undojoin|keeppattern %s/\s\+$//e|$put_|$put_|silent! $;?\(^\s*$\)\@!?+2,$d]])
		vim.fn.setreg("/", register)
		vim.fn.setpos(".", save_pos)
	end,
})

-- disable lsp for filetypes
autocmd({ "FileType" }, {
	group = MyGroup,
	pattern = vim.g.info_file_pattern,
	callback = function()
		vim.diagnostic.disable(0)
	end,
})
