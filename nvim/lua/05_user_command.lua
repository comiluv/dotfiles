local usercmd = vim.api.nvim_create_user_command
-- Converted from https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3 to lua
local function Grep(args)
	local cmd = vim.opt_local.grepprg:get() .. " " .. args
	-- Execute the command and return its output
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Helper function to split lines and filter out empty ones
local function split_and_filter(output)
	return vim.tbl_filter(function(line)
		return line ~= ""
	end, vim.split(output, "\n"))
end

-- Create the `Grep` command
usercmd("Grep", function(opts)
	vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
		vim.fn.setqflist({}, "r", { title = "Grep", lines = results })
		vim.cmd("copen")
	end)
end, { nargs = "+", complete = "file" })

-- New Grepadd (like :grepadd): append to current quickfix list
usercmd("Grepadd", function(opts)
	vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
		vim.fn.setqflist({}, "a", { title = "Grepadd", lines = results })
		vim.cmd("copen")
	end)
end, { nargs = "+", complete = "file" })

-- Create the `LGrep` command
usercmd("LGrep", function(opts)
	vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
		vim.fn.setloclist(0, {}, "r", { title = "LGrep", lines = results })
		vim.cmd("lopen")
	end)
end, { nargs = "+", complete = "file" })

-- New LGrepadd (like :lgrepadd): append to current location list
usercmd("LGrepadd", function(opts)
	vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
		vim.fn.setloclist(0, {}, "a", { title = "LGrepadd", lines = results })
		vim.cmd("lopen")
	end)
end, { nargs = "+", complete = "file" })

vim.keymap.set("ca", "grep", "Grep")
vim.keymap.set("ca", "grepadd", "Grepadd")
vim.keymap.set("ca", "lgrep", "LGrep")
vim.keymap.set("ca", "lgrepadd", "LGrepadd")

-- Close all buffers except the current one
-- Usage: :BufOnly
usercmd("BufOnly", function()
	vim.cmd("%bd|e#|bd#")
end, { desc = "Close all buffers except the current one" })
vim.keymap.set("n", "<leader>bo", "<Cmd>BufOnly<CR>", { desc = "Close all buffers except the current one" })
