-- get lsp from https://github.com/helsmy/vscode-autohotkey
-- reuse vscode-autohotkey lsp client
local lsp_clients = vim.lsp.get_clients({ name = "vscode_autohotkey" })
for _, client in ipairs(lsp_clients) do
	if vim.lsp.buf_is_attached(0, client.id) == false then
		vim.lsp.buf_attach_client(0, client.id)
		return
	end
end

local cmd = {
	"node",
	"C:\\tools\\helsmy.ahk-simple-ls\\extension\\server\\out\\server.js",
	"--stdio",
	"--node-ipc",
}
-- Add files/folders here that indicate the root of a project
local root_markers = { ".git", ".editorconfig" }
-- Change to table with settings if required

local match = vim.fs.find(root_markers, { path = vim.api.nvim_buf_get_name(0), upward = true })[1]
local root_dir = match and vim.fs.dirname(match) or nil
local settings = vim.empty_dict()
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities = require("blink-cmp").get_lsp_capabilities(lsp_capabilities)
vim.lsp.start({
	name = "vscode-autohotkey",
	cmd = cmd,
	root_dir = root_dir,
	settings = settings,
	capabilities = lsp_capabilities,
})
