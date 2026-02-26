-- Buffer-local guard
if vim.b.did_after_ftplugin_cs then
	return
end
vim.b.did_after_ftplugin_cs = true

-- Ensure vcvars.vim is loaded + configured once (session-global)
if jit.os == "Windows" and not vim.g.did_load_vcvars then
	vim.g.did_load_vcvars = true
	pcall(function()
		require("lazy").load({ plugins = { "vcvars.vim" } })
	end)
end
