local cmd = {
	"node",
	"C:\\tools\\helsmy.ahk-simple-ls-0.9.2\\extension\\server\\out\\server.js",
	"--stdio",
	"--node-ipc",
}
-- Add files/folders here that indicate the root of a project
local root_markers = { ".git", ".editorconfig" }
-- Change to table with settings if required
local settings = vim.empty_dict()

local match = vim.fs.find(root_markers, { path = vim.api.nvim_buf_get_name(0), upward = true })[1]
local root_dir = match and vim.fn.fnamemodify(match, ":p:h") or nil

vim.lsp.start({
	name = "vscode-autohotkey",
	cmd = cmd,
	root_dir = root_dir,
	settings = settings,
})

