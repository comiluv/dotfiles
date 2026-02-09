-- Quit if it's C++
if vim.bo.filetype ~= "c" then
	return
end

-- Clang-format default
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- Compiler to use
local compiler = vim.env.CC or "gcc"

-- Check if compiler exists
if vim.fn.executable(compiler) == 0 then
	vim.notify("C Compiler Not Found", vim.log.levels.WARN)
	return
end

local compile_commands = {
	cl = "!cl.exe /W4 /Zi /Fo./obj/ /Fe./bin/",
	cc = "!cc -g -Wall -Wextra -pedantic -o ./bin/",
	gcc = "!gcc -g -Wall -Wextra -pedantic -o ./bin/",
	clang = "!clang -g -Wall -Wextra -pedantic -o ./bin/",
	zig = "!zig cc -g -Wall -Wextra -pedantic -o ./bin/",
}

local compile_command = compile_commands[compiler]

local windows = vim.fn.has("win32") == 1
local windows_extension = ""

-- use msys2 make in Windows
if windows then
	vim.bo.makeprg = "mingw32-make.exe"
	windows_extension = ".exe"
end

-- Output Visual Studio messages in English (rather than system locale). Requires Visual Studio English language pack installed
vim.env.VSLANG = 1033

-- pressing F5 will compile current buffer
vim.keymap.set("n", "<F5>", function()
	local fullpath = vim.api.nvim_buf_get_name(0)
	local filename_only = vim.api.nvim_call_function("fnamemodify", { fullpath, ":t:r" }) .. windows_extension

	local f5_command = compile_command .. (compiler == "cl" and "" or filename_only) .. " %"

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(f5_command)
end, { buffer = true })

-- pressing Shift-F5 will compile all .cpp files
vim.keymap.set("n", "<s-F5>", function()
	local fullpath = vim.api.nvim_buf_get_name(0)
	local filename_only = vim.api.nvim_call_function("fnamemodify", { fullpath, ":t:r" }) .. windows_extension

	local f5_command = compile_command .. filename_only .. " ./*.c"

	vim.cmd.cd("%:p:h")
	vim.cmd.call("mkdir('obj','p')")
	vim.cmd.call("mkdir('bin','p')")
	vim.cmd.update()
	vim.cmd(f5_command)
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
