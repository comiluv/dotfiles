vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
-- Delete netrw buffer after entering a file
vim.g.netrw_fastbrowse = 0

-- Suppress Alt keys in Windows so it can be used as shortcuts
vim.opt.winaltkeys = "no"
if vim.fn.has("unix") == 1 then
	vim.g.python3_host_prog = "/usr/bin/python3"
else
	vim.g.python3_host_prog = "C:\\Windows\\py.exe"
end

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --color never --vimgrep --hidden --iglob !/.git/"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.opt.clipboard = "unnamedplus"

-- Some settings picked up from internet
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = false

vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.opt.redrawtime = 1500

vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.list = false

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.laststatus = 3
-- Better display for messages
vim.opt.cmdheight = 2
-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime = 200

vim.opt.fileformats = "unix,dos"
vim.opt.fileencodings = "ucs-bom,utf-8,euc-kr,default,latin1"
vim.opt.tabpagemax = 100

vim.opt.splitbelow = true
vim.opt.splitright = true

-- You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
-- or have this run as autocmd. See autocmd section.
vim.opt.formatoptions:remove({ "o" })
-- Delete comment character when joining commented lines
vim.opt.formatoptions:append("j")

-- Show invisible characters in this format
vim.opt.listchars = "tab:→ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»"

-- Decent wildmenu
-- vim.opt.path:append "**"
vim.opt.wildmenu = true
vim.opt.wildmode = "list:full"
vim.opt.wildignorecase = true
-- stylua: ignore
vim.opt.wildignore = "*.7z,*.aux,*.avi,*.bak,*.bib,*.class,*.cls,*.cmi,*.cmo,*.doc,*.docx,*.dvi,*.flac,*.flv,*.gem,*.gif,*.hi,*.ico,*.jpeg,*.jpg,*.log,*.min*.js,*.min.js,*.mov,*.mp3,*.mp4,*.mpg,*.nav,*.o,*.obj,*.ods,*.odt,*.ogg,*.opus,*.out,*.pdf,*.pem,*.png,*.rar,*.rbc,*.rbo,*.settings,*.sty,*.svg,*.swp,*.swp*.,*.tar,*.tar.bz2,*.tar.gz,*.tar.xz,*.tgz,*.toc,*.wav,*.webm,*.xcf,*.xls,*.xlsx,*.zip,*/.bundle/*,*/.sass-cache/*,*/vendor/cache/*,*/vendor/gems/*,*~,._*,.git,.hg,.svn,Thumbs.db,Zend,intermediate/*,publish/*,vendor"

vim.opt.sessionoptions:remove("options")
vim.opt.viewoptions:remove("options")

vim.opt.backup = false
vim.opt.undofile = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- Turn off lsp logging because the file size grows beyond control
vim.lsp.set_log_level("off")

vim.o.timeout = true
vim.o.timeoutlen = 500

-- include msys64 usr/bin to use its utils such as gzip, tar, etc.
vim.env.PATH = vim.env.PATH .. ";C:\\tools\\msys64\\usr\\bin"
