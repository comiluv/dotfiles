local ok, alpha = pcall(require,"alpha")
if not ok then return end

local startify = require("alpha.themes.startify")
-- Powershell fortune: https://www.bgreco.net/fortune
-- fortune.txt.dat is produced in WSL
local handle
if vim.fn.has('win32') == 1 then
    handle = assert(io.popen("fortune.ps1|cowsay -W 120 --random", "r"))
else
    handle = assert(io.popen("fortune|cowsay -W 120 --random", "r"))
end
local fortune_raw = assert(handle:read("*a"))
handle:close()

local fortune = {}
for s in string.gmatch(fortune_raw, "[^\r\n]+") do
	table.insert(fortune, s)
end

startify.section.header.val = fortune
alpha.setup(startify.config)

