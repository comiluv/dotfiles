local handle = assert(io.popen("fortune.ps1|cowsay -W 120 --random", "r"))
local fortune_raw = assert(handle:read("*a"))
handle:close()

local fortune = {}
for s in string.gmatch(fortune_raw, "[^\r\n]+") do
	table.insert(fortune, s)
end

local alpha = require("alpha")
local startify = require("alpha.themes.startify")
startify.section.header.val = fortune
alpha.setup(startify.config)

