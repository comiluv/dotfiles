-- clang-format default
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- it'll also be used for C++

-- use msys2 make
if vim.fn.has("win32") == 1 then
	vim.bo.makeprg = "mingw32-make.exe"
end

-- pressing F5 will call make to compile it
vim.keymap.set("n", "<F5>", function()
	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd("!cl.exe /Zi /Wall /std:clatest /Fo.\\obj\\ /Fe.\\bin\\ %")
end, { buffer = true })

-- pressing F5 key in insert mode or visual mode will exit respective mode
-- and press F5 in normal mode
vim.keymap.set({ "i", "v" }, "<F5>", "<ESC><F5>", { buffer = true, remap = true })

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
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { buffer = true, remap = true })

-- flags
-- gcc flags
-- vim.env.CFLAGS = "-Wall -Wextra -pedantic -g"
-- vim.env.CXXFLAGS = "-Wall -Wextra -pedantic -g -std=c++17"
-- cl flags
vim.env.CFLAGS = "/Wall /Zi"
vim.env.CXXFLAGS = "/EHsc /Wall /wd4668 /Zi /std:c++20"

vim.env.CC = "cl.exe"
vim.env.CXX = "cl.exe"

-- requires Visual Studio English language pack installed
vim.env.VSLANG = 1033
