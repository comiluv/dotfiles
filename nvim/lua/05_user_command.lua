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

-- Create the `LGrep` command
usercmd("LGrep", function(opts)
	vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
		vim.fn.setloclist(0, {}, "r", { title = "LGrep", lines = results })
		vim.cmd("lopen")
	end)
end, { nargs = "+", complete = "file" })

vim.keymap.set("ca", "grep", "Grep")
vim.keymap.set("ca", "lgrep", "LGrep")

-- Make ClearShada user command to workaround Neovim creating endlessly empty main.shada.tmp.X files in $ENV:LocalAppData/nvim-data/shada
-- https://github.com/neovim/neovim/issues/8587#issuecomment-2176399196
usercmd("ClearShada", function()
	local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
	local files = vim.fn.glob(shada_path .. "/*", false, true)
	local all_success = 0
	for _, file in ipairs(files) do
		local file_name = vim.fn.fnamemodify(file, ":t")
		if file_name == "main.shada" then
			-- skip your main.shada file
			goto continue
		end
		local success = vim.fn.delete(file)
		all_success = all_success + success
		if success ~= 0 then
			vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
		end
		::continue::
	end
	if all_success == 0 then
		vim.notify("Successfully deleted all temporary shada files", vim.log.levels.INFO)
	end
end, { desc = "Clears all the .tmp shada files" })

-- Close all buffers except the current one
-- Usage: :BufOnly
usercmd("BufOnly", function()
	vim.cmd("%bd|e#|bd#")
end, { desc = "Close all buffers except the current one" })
vim.keymap.set("n", "<leader>bo", "<Cmd>BufOnly<CR>", { desc = "Close all buffers except the current one" })
