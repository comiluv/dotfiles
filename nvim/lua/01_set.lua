if vim.fn.has("unix") == 1 then
	vim.g.python3_host_prog = "/usr/bin/python3"
else
	vim.g.python3_host_prog = "C:\\Windows\\py.exe"
end

vim.schedule(function()
	if vim.fn.executable("rg") then
		vim.opt.grepprg = "rg --no-heading --color never --vimgrep"
		vim.opt.grepformat = "%f:%l:%c:%m"
	end

	vim.opt.clipboard = "unnamedplus"
end)

vim.g.netrw_winsize = 25
-- Delete netrw buffer after entering a file
vim.g.netrw_fastbrowse = 0
-- Show line numbers in Netrw
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro nornu"

-- Suppress Alt keys in Windows so it can be used as shortcuts
vim.opt.winaltkeys = "no"

-- Some settings picked up from internet
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.breakindent = true

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- Set 'textwidth' and set 'colorcolumn' relative to 'textwidth', only when needed
vim.opt.colorcolumn = "+1"
vim.opt.signcolumn = "yes"
vim.opt.title = true
vim.opt.laststatus = 3
-- Plugin lualine does what 'showmode' does and more
vim.opt.showmode = false
-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime = 200

vim.opt.fileformats = "unix,dos"
vim.opt.fileencodings = "ucs-bom,utf-8,euc-kr,default,latin1"
vim.opt.tabpagemax = 100

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show invisible characters in this format
-- stylua: ignore
vim.opt.listchars = { tab = "→ ", lead = "·", space = "·", nbsp = "␣", trail = "•", eol = "¶", precedes = "«", extends = "»" }

-- Decent wildmenu
vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.opt.wildmode = "list:full"
vim.opt.wildignorecase = true
-- stylua: ignore
vim.opt.wildignore = "*/.git/*"

vim.opt.undofile = true

-- Folding
vim.opt.foldlevelstart = 99

-- Include msys64 usr/bin to use its utils such as gzip, tar, etc.
vim.env.PATH = vim.env.PATH .. ";C:\\msys64\\usr\\bin"

-- Treat .h files as C
vim.g.c_syntax_for_h = true

-- Save language settings configured on each buffer
vim.opt.sessionoptions:append("localoptions")

-- Additional extensions for Zip Plugin
vim.g.zipPlugin_ext =
	"*.aar,*.apk,*.celzip,*.crtx,*.docm,*.docx,*.dotm,*.dotx,*.ear,*.epub,*.gcsx,*.glox,*.gqsx,*.ja,*.jar,*.kmz,*.odb,*.odc,*.odf,*.odg,*.odi,*.odm,*.odp,*.ods,*.odt,*.otc,*.otf,*.otg,*.oth,*.oti,*.otp,*.ots,*.ott,*.oxt,*.potm,*.potx,*.ppam,*.ppsm,*.ppsx,*.pptm,*.pptx,*.sldx,*.thmx,*.vdw,*.war,*.wsz,*.xap,*.xlam,*.xlsb,*.xlsm,*.xlsx,*.xltm,*.xltx,*.xpi,*.zip,*.pak"
