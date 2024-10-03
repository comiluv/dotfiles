local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup("MyGroup", {})
local TrimGroup = augroup("TrimGroup", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

vim.g.info_filetype = {
	"''",
	"PlenaryTestPopup",
	"TelescopePrompt",
	"TelescopeResults",
	"Trouble",
	"chatgpt",
	"checkhealth",
	"dap-repl",
	"diff",
	"fugitive",
	"gitcommit",
	"gitrebase",
	"help",
	"hgcommit",
	"lazy",
	"lspinfo",
	"man",
	"markdown",
	"memento",
	"netrw",
	"notify",
	"packer",
	"qf",
	"spectre_panel",
	"startuptime",
	"svn",
	"tsplayground",
	"undotree",
}

local trim_exclusions = {
	"markdown",
}

-- Flash yanked text after yanking
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
		vim.opt_local.formatoptions:remove("o")
		-- auto remove comment when joining lines with <J> key
		vim.opt_local.formatoptions:append("j")
	end,
})

-- close some filetypes with <q>
autocmd({ "FileType" }, {
	group = MyGroup,
	pattern = vim.g.info_filetype,
	callback = function(event)
		vim.opt_local.buflisted = false
		vim.keymap.set("n", "q", "<cmd>silent! close<cr>", { buffer = event.buf, nowait = true })
	end,
})

-- enter insert mode in Terminal automatically
autocmd({ "TermOpen" }, {
	group = MyGroup,
	pattern = "*",
	command = "startinsert",
})

-- trim whitespace and put one blank line at the end
-- source 1: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim/7501902#7501902
-- source 2: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
-- source 3: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
autocmd("BufWritePre", {
	group = TrimGroup,
	pattern = "*",
	callback = function()
		-- Only trim if the buffer is modifiable
		if not vim.opt_local.modifiable:get() then
			return
		end
		-- Only trim when there's no formatter attached
		vim.b.num_formatters = vim.b.num_formatters or #(require("conform").list_formatters())
		if vim.b.num_formatters > 0 then
			return
		end
		for _, filetype in ipairs(trim_exclusions) do
			if vim.opt_local.filetype:get() == filetype then
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
	pattern = vim.g.info_filetype,
	callback = function()
		vim.diagnostic.disable(0)
	end,
})

-- disable <esc><esc> keymap in lazygit window
autocmd({ "FileType" }, {
	group = MyGroup,
	pattern = "lazygit",
	callback = function()
		vim.keymap.set("t", "<ESC><ESC>", "<NOP>", { buffer = true })
	end,
})

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
autocmd({ "LspAttach" }, {
	group = MyGroup,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})
