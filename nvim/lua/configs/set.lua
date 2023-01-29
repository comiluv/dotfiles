-- Suppress Alt keys in Windows so it can be used as shortcuts
vim.opt.winaltkeys="no"

-- Some settings picked up from internet
vim.opt.shiftwidth=4
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.expandtab=true

vim.opt.termguicolors=true

vim.opt.smartindent=true
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.wrap=true
vim.opt.linebreak=true
vim.opt.list=false
vim.opt.hlsearch=false
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.scrolloff=8
vim.opt.sidescrolloff=5
vim.opt.signcolumn="yes"
vim.opt.ruler=true
vim.opt.fileencodings="ucs-bom,utf-8,euc-kr,default,latin1"
vim.opt.tabpagemax=100
vim.opt.colorcolumn="80"
vim.opt.title=true
vim.opt.cursorline=true
vim.opt.completeopt="menuone,noinsert,noselect"
vim.opt.splitbelow=true
vim.opt.splitright=true
-- Better display for messages
vim.opt.cmdheight=2
-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime=50

-- You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
-- or have this run as autocmd. See autocmd section.
vim.opt.formatoptions:remove {"o"}
-- Delete comment character when joining commented lines
vim.opt.formatoptions:append {"j"}

-- Show invisible characters in this format
vim.opt.listchars="tab:→ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»"

-- Decent wildmenu
-- vim.opt.path:append {"**"}
vim.opt.wildmenu=true
vim.opt.wildmode="list:full"
vim.opt.wildignore=".hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor"
vim.opt.wildignore:append {"*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem"}
vim.opt.wildignore:append {"*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz"}
vim.opt.wildignore:append {"*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*"}
vim.opt.wildignore:append {"*.swp,*~,._*"}

vim.opt.shortmess=""
-- This is needed to avoid swapfile warning when auto-reloading
-- vim.opt.shortmess:append "A"

vim.opt.sessionoptions:remove {"options"}
vim.opt.viewoptions:remove {"options"}

vim.opt.swapfile=false
vim.opt.backup=false
vim.opt.undofile=true

vim.g.mapleader=" "
-- Drop powershell and revert back to cmd for Windows because powershell is too
-- slow and most plugins assume to use cmd in Windows

