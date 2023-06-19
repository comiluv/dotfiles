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

local function lspFormatter(client)
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities.documentFormattingProvider == false
	then
		return false
	end

	if not client.supports_method("textDocument/formatting") then
		return false
	end

	local formatters = { "null-ls", "clangd" }
	for _, v in ipairs(formatters) do
		if v == client.name then
			return true
		end
	end
	return false
end

-- autoformat on save
autocmd("LspAttach", {
	group = augroup("LspFormatOnSave", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if not lspFormatter(client) then
			return
		end

		local buf = ev.buf
		autocmd("BufWritePre", {
			group = augroup("LspFormatOnSave" .. buf, {}),
			buffer = buf,
			callback = function()
				vim.lsp.buf.format({ timeout_ms = 10000, name = client.name })
			end,
		})
	end,
})

-- lsp format
autocmd("LspAttach", {
	group = augroup("LspFormatHotkey", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local client_name = client.name

		if not lspFormatter(client) then
			return
		end

		if client_name == "null-ls" then
			local buffer_clients = vim.lsp.get_active_clients({ bufnr = 0 })
			for _, buffer_client in ipairs(buffer_clients) do
				if buffer_client.name == "clangd" then
					return
				end
			end
		end

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ timeout_ms = 10000, name = client_name })
		end, { buffer = true, desc = "Format buffer" })
	end,
})
