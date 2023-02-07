local ok, barbecue_ui = pcall(require, "barbecue.ui")
if not ok then return end

local events = {
	"BufWinEnter",
	"CursorHold",
	"InsertLeave",
}

if vim.fn.has("nvim-0.9") == 1 then
	table.insert(events, "WinResized")
end

vim.api.nvim_create_autocmd(events, {
	group = vim.api.nvim_create_augroup("barbecue.updater", {}),
	callback = function()
		barbecue_ui.update()
	end,
})

