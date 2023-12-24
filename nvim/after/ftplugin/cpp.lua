-- clang-format default
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

local windows = vim.fn.has("win32") == 1

-- use msys2 make
if windows then
	vim.bo.makeprg = "mingw32-make.exe"
end

-- pressing F5 will call make to compile it
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
		fullpath = fullpath:sub(1, #fullpath - #dot - 1) .. ".exe"
	end

	local cl = "!cl.exe /W4 /wd4458 /EHsc /Zi /std:c++latest /O2 /Fo.\\obj\\ /Fe.\\bin\\ %"
	local gcc = "!g++.exe -g -std=c++2a -O2 -Wall % -o .\\bin\\" .. fullpath
	local clang = "!clang++.exe -g -std=c++2a -O2 -Wall % -o .\\bin\\" .. fullpath

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(clang)
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
		fullpath = fullpath:sub(1, #fullpath - #dot - 1) .. ".exe"
	end

	local cl = "!cl.exe /W4 /wd4458 /EHsc /Zi /std:c++latest /O2 /Fo.\\obj\\ /Fe.\\bin\\" .. fullpath .. " .\\*.cpp"
	local gcc = "!g++.exe -g -std=c++2a -O2 -Wall .\\*.cpp -o .\\bin\\" .. fullpath
	local clang = "!clang++.exe -g -std=c++2a -O2 -Wall .\\*.cpp -o .\\bin\\" .. fullpath

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(clang)
end, { buffer = true })

-- pressing F5 key in insert mode or visual mode will exit respective mode
-- and press F5 in normal mode
vim.keymap.set({ "i", "x" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })
vim.keymap.set({ "i", "x" }, "<s-F5>", "<ESC><s-F5>", { buffer = true, remap = true })

-- pressing f8 will run the executable
if vim.fn.has("win32") == 1 then
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

-- flags
-- gcc flags
-- vim.env.CFLAGS = "-Wall -Wextra -pedantic -g -std=c2x"
-- vim.env.CXXFLAGS = "-Wall -Wextra -pedantic -g -std=c++17"
-- cl flags
vim.env.CFLAGS = "/W4 /Zi /std:clatest"
vim.env.CXXFLAGS = "/EHsc /W4 /wd4668 /Zi /std:c++latest"

vim.env.CC = "cl.exe"
vim.env.CXX = "cl.exe"

-- requires Visual Studio English language pack installed
vim.env.VSLANG = 1033
