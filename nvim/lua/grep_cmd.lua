-- Converted from https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3 to lua
local M = {}
M.setup = function()
	-- Define a function `Grep` that mimics the behavior of the Vimscript function
	local function Grep(args)
		local cmd = vim.opt.grepprg:get() .. " " .. args
		-- Execute the command and return its output
		return vim.fn.system(cmd)
	end

	-- Helper function to split lines and filter out empty ones
	local function split_and_filter(output)
		return vim.tbl_filter(function(line)
			return line ~= ""
		end, vim.split(output, "\n"))
	end

	-- Create the `Grep` command
	vim.api.nvim_create_user_command("Grep", function(opts)
		vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
			vim.fn.setqflist({}, "r", { title = "Grep", lines = results })
			vim.cmd("copen")
		end)
	end, { nargs = "+", complete = "file" })

	-- Create the `LGrep` command
	vim.api.nvim_create_user_command("LGrep", function(opts)
		vim.schedule(function()
		local results = split_and_filter(Grep(opts.args))
			vim.fn.setloclist(0, {}, "r", { title = "LGrep", lines = results })
			vim.cmd("lopen")
		end)
	end, { nargs = "+", complete = "file" })

	-- Abbreviations for `grep` and `lgrep` commands
	vim.cmd([[
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'
]])
end
return M
