-- clang-format default
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

local windows = vim.fn.has("win32") == 1
local windows_extension = ""

-- use msys2 make in Windows
if windows then
	vim.bo.makeprg = "mingw32-make.exe"
	windows_extension = ".exe"
end

-- Default compiler command lines for each compiler
local cl = "!cl.exe /W4 /wd4458 /EHsc /Zi /std:c++latest /O2 /Fo./obj/ /Fe./bin/"
local gcc = "!g++ -g -std=c++2b -O2 -Wall -o ./bin/"
local clang = "!clang++ -g -std=c++2b -O2 -Wall -o ./bin/"

-- pressing F5 will compile current buffer
vim.keymap.set("n", "<F5>", function()
	local fullpath = vim.api.nvim_buf_get_name(0)
	local last_slash = fullpath:match(".*%/(.*)$")
	if last_slash then
		fullpath = last_slash
	elseif windows then
		local last_backslash = fullpath:match(".*%\\(.*)$")
		if last_backslash then
			fullpath = last_backslash
		end
	end
	local dot = fullpath:match(".*%.(.*)")
	if dot then
		fullpath = fullpath:sub(1, #fullpath - #dot - 1) .. windows_extension
	end

	local cl = cl .. " %"
	local gcc = gcc .. fullpath .. " %"
	local clang = clang .. fullpath .. " %"

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(gcc)
end, { buffer = true })

-- pressing Shift-F5 will compile all .cpp files
vim.keymap.set("n", "<s-F5>", function()
	local fullpath = vim.api.nvim_buf_get_name(0)
	local last_slash = fullpath:match(".*%/(.*)$")
	if last_slash then
		fullpath = last_slash
	elseif windows then
		local last_backslash = fullpath:match(".*%\\(.*)$")
		if last_backslash then
			fullpath = last_backslash
		end
	end
	local dot = fullpath:match(".*%.(.*)")
	if dot then
		fullpath = fullpath:sub(1, #fullpath - #dot - 1) .. windows_extension
	end

	local cl = cl .. fullpath .. " ./*.cpp"
	local gcc = gcc .. fullpath .. " ./*.cpp"
	local clang = clang .. fullpath .. " ./*.cpp"

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(gcc)
end, { buffer = true })

-- pressing F5 key in insert mode or visual mode will exit respective mode
-- and press F5 in normal mode
vim.keymap.set({ "i", "x" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })
vim.keymap.set({ "i", "x" }, "<s-F5>", "<ESC><s-F5>", { buffer = true, remap = true })

-- pressing f8 will run the executable
if windows then
	vim.keymap.set("n", "<f8>", function()
		vim.cmd.cd("%:p:h")
		vim.cmd.exec("'term' shellescape('bin/' .. expand('%<')..'.exe')")
	end, { buffer = true })
else
	vim.keymap.set("n", "<f8>", function()
		vim.cmd.cd("%:p:h")
		vim.cmd.exec("'term' shellescape('bin/'..expand('%<'))")
	end, { buffer = true })
end

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "x" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })

-- Vim can use environmental variables when compiling using make
-- vim.env.CFLAGS = "-Wall -Wextra -pedantic -g -std=c2x"
-- vim.env.CXXFLAGS = "-Wall -Wextra -pedantic -g -std=c++17"

-- vim.env.CC = "cl.exe"
-- vim.env.CXX = "cl.exe"

-- Output Visual Studio messages in English (rather than system locale). Requires Visual Studio English language pack installed
vim.env.VSLANG = 1033
