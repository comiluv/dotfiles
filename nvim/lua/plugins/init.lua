--[[
List of plugins that Neovim(lua) version is desired
{
	www.github.com/mbbill/undotree         : Vimscript
                                           : http://github.com/debugloop/telescope-undo.nvim but not equivalent
	www.github.com/andymass/vim-matchup    : Vimscript
	www.github.com/junegunn/vim-easy-align : Vimscript
}
]]

-- { "BufRead", "BufNewFile", } -- note the new buffer opened by :enew
-- doesn't trigger neighther of the events
-- but keep it this way because other events
-- such as "CursorHold", "CursorMoved", are
-- triggered as soon as Netrw is opened: not what I want.
-- Adding "InsertEnter" is to be avoided because
-- Telescope triggers "InsertEnter" event and I want to
-- seperate plugin loading into "BufRead" and "InsertEnter"

-- many of the config code in this folder was taken from https://github.com/LazyVim/LazyVim

return {
	{ "folke/lazy.nvim", version = "*" },
}
