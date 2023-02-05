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
		require("barbecue.ui").update()
	end,
})
