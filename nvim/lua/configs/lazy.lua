local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- fix drag-n-drop functionality for neovim-qt
-- see https://github.com/folke/lazy.nvim/issues/403
local opts = {
	performance = {
		rtp = {
			reset = false,
		},
	},
}

require("lazy").setup("plugins", opts)
