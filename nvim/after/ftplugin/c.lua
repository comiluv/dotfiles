-- it'll also be used for C++

-- pressing F5 will call make to compile it
vim.keymap.set("n", "<F5>", ":<C-u>w!<bar>make %<<CR>", { buffer = true })

-- pressing F5 key in insert mode or visual mode will exit respective mode
-- and press F5 in normal mode
vim.keymap.set({ "i", "v" }, "<F5>", "<ESC><F5>", { buffer =true, remap = true })

-- pressing f8 will run the executable
if vim.fn.has("win32") == 1 then
	if vim.o.shell == "cmd.exe" then
		vim.keymap.set("n", "<f8>", ":<C-u>exec 'term' shellescape(expand('%<')..'.exe')<CR>", { buffer = true })
	else
		vim.keymap.set("n", "<f8>", ":<C-u>exec 'term &' shellescape(expand('%<')..'.exe')<CR>", { buffer = true })
	end
else
	vim.keymap.set("n", "<f8>", ":<C-u>exec 'term' shellescape('./'..expand('%<'))<CR>", { buffer = true })
end

-- just like above, pressing F8 in insert mode or visual mode will exit respective
-- mode and press F8
vim.keymap.set({ "i", "v" }, "<F8>", "<ESC><F8>", { buffer =true, remap = true })

-- flags
vim.env.CFLAGS = "-Werror -Wall -Wextra -pedantic -g"
vim.env.CXXFLAGS = vim.env.CFLAGS

