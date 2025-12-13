-- auto install folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
		:wait().code
	if out ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- fix drag-n-drop functionality for neovim-qt
-- see https://github.com/folke/lazy.nvim/issues/403
local opts = {
	spec = { import = "plugins" },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"matchit",
				"matchparen",
			},
		},
	},
}

require("lazy").setup(opts)
