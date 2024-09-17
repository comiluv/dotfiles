-- { "BufReadPre", "BufNewFile", } -- note the new buffer opened by :enew
-- doesn't trigger neighther of the events
-- but keep it this way because other events
-- such as "CursorHold", "CursorMoved", are
-- triggered as soon as Netrw is opened: not what I want.
-- Adding "InsertEnter" is to be avoided because
-- Telescope triggers "InsertEnter" event and I want to
-- seperate plugin loading into "BufReadPre" and "InsertEnter"

-- much of the config code in this folder was taken from https://github.com/LazyVim/LazyVim

return {
	{ "folke/lazy.nvim", version = "*" },
}
