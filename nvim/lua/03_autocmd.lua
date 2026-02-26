local augroup = function(name, opts)
	opts = opts or { clear = true }
	return vim.api.nvim_create_augroup(name, opts)
end

local autocmd = vim.api.nvim_create_autocmd

vim.g.info_filetype = {
	"PlenaryTestPopup",
	"TelescopePrompt",
	"TelescopeResults",
	"Trouble",
	"ada",
	"chatgpt",
	"checkhealth",
	"codecompanion",
	"dap-repl",
	"diff",
	"fugitive",
	"gitcommit",
	"gitrebase",
	"gitsigns-blame",
	"help",
	"hgcommit",
	"ini",
	"lazy",
	"lspinfo",
	"man",
	"markdown",
	"memento",
	"netrw",
	"notify",
	"packer",
	"prompt", -- bt: snacks_picker_input
	"qf",
	"snacks_dashboard",
	"snacks_input",
	"snacks_notif",
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
	group = augroup("HighlightYank"),
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove inserting comment marker the cursor is on a comment and open a new line
autocmd({ "FileType" }, {
	group = augroup("NoCommentNewLine"),
	callback = function()
		vim.opt_local.formatoptions:remove("o")
		-- auto remove comment when joining lines with <J> key
		vim.opt_local.formatoptions:append("j")
	end,
})

-- close some filetypes with <q>
autocmd({ "FileType" }, {
	group = augroup("InfoBufferCloseWithQ"),
	pattern = vim.g.info_filetype,
	callback = function(event)
		vim.keymap.set("n", "q", function()
			if vim.bo[event.buf].filetype == "TelescopePrompt" then
				vim.cmd("bd!")
			else
				vim.cmd("bd")
			end
		end, { buffer = event.buf, nowait = true, desc = "Quick bd for info buffers" })
	end,
})

-- enter insert mode in Terminal automatically
autocmd({ "TermOpen" }, {
	group = augroup("TermInsertMode"),
	command = "startinsert",
})

-- trim whitespace. Use 'set fixendofline' to append EOL at the end of file
-- source 1: https://stackoverflow.com/questions/7495932/how-can-i-trim-blank-lines-at-the-end-of-file-in-vim/7501902#7501902
-- source 2: https://vim.fandom.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
-- source 3: https://vi.stackexchange.com/questions/454/whats-the-simplest-way-to-strip-trailing-whitespace-from-all-lines-in-a-file
autocmd("BufWritePre", {
	group = augroup("TrimWhitespace"),
	callback = function()
		-- Only trim if the buffer is "normal buffer"
		if vim.bo.buftype ~= "" then
			return
		end
		-- Only trim when there's no formatter attached
		vim.b.num_formatters = vim.b.num_formatters or #(require("conform").list_formatters())
		if vim.b.num_formatters > 0 then
			return
		end
		for _, filetype in ipairs(trim_exclusions) do
			if vim.bo.filetype == filetype then
				return
			end
		end

		local view = vim.fn.winsaveview()
		vim.cmd([[silent! undojoin|keeppatterns %s/\s\+$//e|$put_|silent! $;?\(^\s*$\)\@!?+1,$delete _]])
		vim.fn.winrestview(view)
	end,
})

-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
autocmd({ "LspAttach" }, {
	group = augroup("KickstartLspAttach"),
	callback = function(event)
		local highlight_augroup = augroup("KickstartLspHighlight")
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
				group = highlight_augroup,
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "KickstartLspHighlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Search highlight behavior and consistent n/N navigation
-- See https://github.com/rktjmp/highlight-current-n.nvim?tab=readme-ov-file#neovim-09
local hlsearch_group = augroup("SearchHLTweaks")

autocmd("ColorScheme", {
	group = hlsearch_group,
	callback = function()
		local search_hl = vim.api.nvim_get_hl(0, { name = "Search" })
		vim.api.nvim_set_hl(0, "CurSearch", { link = "IncSearch" })
		vim.api.nvim_set_hl(0, "SearchCurrentN", search_hl)
		vim.api.nvim_set_hl(0, "Search", { link = "SearchCurrentN" })
	end,
})

autocmd("CmdlineEnter", {
	group = hlsearch_group,
	pattern = { "/", "?" },
	callback = function()
		vim.opt.hlsearch = true
		vim.opt.incsearch = true
		vim.api.nvim_set_hl(0, "Search", { link = "SearchCurrentN" })
	end,
})

autocmd("CmdlineLeave", {
	group = hlsearch_group,
	pattern = { "/", "?" },
	callback = function()
		vim.api.nvim_set_hl(0, "Search", {})
		vim.defer_fn(function()
			vim.opt.hlsearch = true
		end, 5)
	end,
})

autocmd({ "InsertEnter", "CursorMoved" }, {
	group = hlsearch_group,
	callback = function()
		vim.schedule(function()
			vim.cmd("nohlsearch")
		end)
	end,
})

local function repeat_search_consistent(key)
	local function flipped(k)
		return (k == "n") and "N" or "n"
	end

	local effective_key = (vim.v.searchforward == 0) and flipped(key) or key
	local count = vim.v.count1
	local keys = tostring(count) .. effective_key .. "zzzv"

	vim.api.nvim_feedkeys(keys, "n", false)

	vim.defer_fn(function()
		vim.opt.hlsearch = true
	end, 5)
end

vim.keymap.set("n", "n", function()
	repeat_search_consistent("n")
end, { silent = true, desc = "Repeat search forward" })
vim.keymap.set("n", "N", function()
	repeat_search_consistent("N")
end, { silent = true, desc = "Repeat search backward" })

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("AutoCreateDir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fs.dirname(file), "p")
	end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("AutoReloadFile"),
	callback = function()
		if vim.bo.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Make sure ShaDa temp files that are empty are deleted on exit
-- https://github.com/neovim/neovim/issues/8587#issuecomment-3557794273
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	group = augroup("DeleteEmptyShaDaTempFiles"),
	pattern = { "*" },
	callback = function()
		local status = 0
		local shada_dir = vim.g.stdpath_data .. "/shada"
		local handle = vim.uv.fs_scandir(shada_dir)
		if handle then
			while true do
				local name = vim.uv.fs_scandir_next(handle)
				if not name then
					break
				end
				if name:find("tmp") then
					local path = shada_dir .. "/" .. name
					local stat = vim.uv.fs_stat(path)
					if stat and stat.size == 0 then
						if not os.remove(path) then
							status = status + 1
						end
					end
				end
			end
		else
			vim.notify("Could not find ShaDa directory", vim.log.levels.ERROR)
			vim.fn.getchar()
		end
		if status ~= 0 then
			vim.notify("Could not delete empty temporary ShaDa files.", vim.log.levels.ERROR)
			vim.fn.getchar()
		end
	end,
	desc = "Delete empty temp ShaDa files",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("ResizeSplits"),
	callback = function()
		local current_tab = vim.api.nvim_get_current_tabpage()
		vim.cmd("tabdo wincmd =")
		vim.api.nvim_set_current_tabpage(current_tab)
	end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("LastLocRestore"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("ManCloseWithQ"),
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("WrapAndSpellCheck"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.wo.wrap = true
		vim.wo.spell = true
	end,
})
