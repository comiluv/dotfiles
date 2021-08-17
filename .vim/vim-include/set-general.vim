" Suppress Alt keys in Windows so it can be used as shortcuts
set winaltkeys=no

if has ("syntax")
    syntax on
endif

" Vim's default behavior
if &compatible
    set nocompatible
endif

" Some settings picked up from internet
set autoread
set autoindent
set smarttab
set shiftwidth=4
set tabstop=4 softtabstop=4
set expandtab
set smartindent
filetype plugin indent on
set number
set wrap linebreak nolist
set nohlsearch
set incsearch
if has('nvim')
    set inccommand=nosplit
endif
set scrolloff=8
set hidden
set ruler
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-kr,latin1
set tenc=utf-8
set bs=indent,eol,start
set history=10000
set colorcolumn=80
set signcolumn=yes
set laststatus=2
set ttyfast
if exists('g:neovide')
    set notitle
else
    set lazyredraw
    set title
endif
set showcmd
set mouse=a
set cursorline
set completeopt=menuone,noinsert,noselect
set splitbelow splitright
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=50

set formatoptions-=o " You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
" or have this run as autocmd. See autocmd section.
set path+=**

" Show invisible characters in this format
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

" Decent wildmenu
set wildmenu
set wildmode=list:full
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*

" This is needed to avoid swapfile warning when auto-reloading
set shortmess+=A

if !has('nvim')
    " Avoids swapfiles in current directory - neovim has default
    if &directory =~# '^\.,'
        if !empty($HOME)
            if has('win32')
                let &directory = expand('$HOME/vimfiles') . '//,' . &directory
            else
                let &directory = expand('$HOME/.vim') . '//,' . &directory
            endif
        endif
        if !empty($XDG_DATA_HOME)
            let &directory = expand('$XDG_DATA_HOME') . '//,' . &directory
        endif
        if has('macunix')
            let &directory = expand('$HOME/Library/Autosave Information') . '//,' . &directory
        endif
    endif
    " Enable undofile and set undodir and backupdir for vim - neovim has default
    " locations : https://neovim.io/doc/user/vim_diff.html#vim-differences
    let s:dir = has('win32') ? '$HOME/vimfiles' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
    let &backupdir = expand(s:dir) . '/backup//'
    let &undodir = expand(s:dir) . '/undo//'
elseif has('nvim')
    let s:dir = has('win32') ? '$LOCALAPPDATA/nvim-data' : '$HOME/.local/share/nvim'
    let &backupdir=expand(s:dir) . '/backup//'
    let &undodir=expand(s:dir) . '/undo//'
endif
" Automatically create directories for backup and undo files.
if !isdirectory(expand(s:dir))
    call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
endif
set undofile
set backup
set nowritebackup " writebackup can cause problems? https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim

" Drop powershell and revert back to cmd for Windows because powershell is too
" slow and most plugins assume to use cmd in Windows

