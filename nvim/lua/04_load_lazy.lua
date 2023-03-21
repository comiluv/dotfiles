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
				"2html_plugin",
				"bugreport",
				"compiler",
				"did_load_filetypes",
				"ftplugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"man",
				"matchit",
				"matchparen",
				"optwin",
				"perl_provider",
				"rplugin",
				"rrhelper",
				"ruby_provider",
				"spellfile",
				"spellfile_plugin",
				"synmenu",
				"syntax",
				"tar",
				"tarPlugin",
				"tohtml",
				"tutor",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
			},
		},
	},
}

require("lazy").setup("plugins", opts)

