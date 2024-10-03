-- Load core configuration modules
require("01_set")
require("02_remap")
require("03_autocmd")
require("04_load_lazy")
require("05_user_command")

if vim.g.neovide then
	-- Neovide-specific settings
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_theme = "light"
	vim.g.neovide_cursor_animation_length = 0 -- Turn off cursor animation completely
	vim.g.neovide_scroll_animation_length = 0.05
	vim.g.neovide_hide_mouse_when_typing = true
end
