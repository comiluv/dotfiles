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
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove inserting comment marker the cursor is on a comment and open a new line
autocmd({ "FileType" }, {
	group = MyGroup,
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
	command = "startinsert",
})

-- trim whitespace and put one blank line at the end
-- source 1: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim/7501902#7501902
-- source 2: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
-- source 3: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
autocmd("BufWritePre", {
	group = TrimGroup,
	callback = function()
		-- Only trim if the buffer is "normal buffer"
		if vim.opt_local.buftype:get() ~= "" then
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

		local view = vim.fn.winsaveview()
		vim.cmd([[silent! undojoin|keeppatterns %s/\s\+$//e|$put_|$put_|silent! $;?\(^\s*$\)\@!?+2,$delete _]])
		vim.fn.winrestview(view)
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
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = augroup("kickstart-lsp-highlight", { clear = false })
			autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			autocmd("LspDetach", {
				group = augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Set folding method for each buffer
-- See https://github.com/nvim-treesitter/nvim-treesitter/issues/1100#issuecomment-1762594005
autocmd({ "BufAdd", "BufReadPre" }, {
	group = augroup("TreesitterFoldingGroup", {}),
	callback = function(event)
		if vim.b.treesitter_folding_set or event.file == "" then
			return
		end
		vim.b.treesitter_folding_set = true
		local ok, size = pcall(vim.fn.getfsize, event.file)
		-- File exists and small enough for tree-sitter folding
		if ok and size > 0 and size < 1024 * 1024 then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt_local.foldtext = "v:lua.vim.treesitter.foldtext()"
		end
	end,
})
