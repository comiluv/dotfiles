-- example configuration! (see CONFIG above to make your own)
require("null-ls").config({
	sources = { require("null-ls").builtins.formatting.stylua },
})
require("lspconfig")["null-ls"].setup({
	-- on_attach = function(client)
	-- 	if client.resolved_capabilities.document_formatting then
	-- 		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	-- 	end
	-- end,
})
