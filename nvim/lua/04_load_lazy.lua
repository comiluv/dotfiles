-- auto install folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
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

require("lazy").setup(opts)
