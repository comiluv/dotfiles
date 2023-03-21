-- auto install folke/lazy.nvim
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

-- fix drag-n-drop functionality for neovim-qt
-- see https://github.com/folke/lazy.nvim/issues/403
local opts = {
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			reset = false,
			disabled_plugins = {
				"editorconfig",
				"health",
				"gzip",
				"man",
				"matchit",
				"matchparen",
				"perl_provider",
				"rplugin",
				"ruby_provider",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}

require("lazy").setup("plugins", opts)

