-- note placing files in /plugin directory did NOT improve start up time
-- this structure is about 10 ms faster in hyperfine results
vim.opt.shadafile = "NONE"

require("01_set")
require("02_remap")
require("03_autocmd")
require("04_load_lazy")

if vim.g.neovide then
	vim.o.guifont = "SFMono_Nerd_Font,D2CodingLigature_Nerd_Font,Noto_Color_Emoji:h11"
	vim.g.neovide_refresh_rate_idle = 5
	vim.g.neovide_theme = "light"
	-- Turn off cursor animation completely
	-- vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_hide_mouse_when_typing = true
end

vim.opt.shadafile = ""
