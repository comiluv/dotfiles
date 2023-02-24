-- note placing files in /plugin directory did NOT improve start up time
-- this structure is about 10 ms faster in hyperfine results
vim.opt.shadafile = "NONE"

require("01_set")
require("02_remap")
require("03_autocmd")
require("04_load_lazy")

vim.opt.shadafile = ""

