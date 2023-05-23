" Suppress Alt keys in Windows so it can be used as shortcuts
set winaltkeys=no

" Vim's default behavior
if &compatible
    set nocompatible
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Some settings picked up from internet
set autoread
set autoindent
set tabstop=8
set shiftwidth=8
set softtabstop=0
set noexpandtab
set smarttab
set smartindent
set complete-=i
set number
set relativenumber
set nrformats-=octal
set wrap linebreak breakindent nolist
set hlsearch
set incsearch
set ignorecase
set smartcase
set scrolloff=4
set sidescrolloff=4
set display+=lastline
set hidden
set ruler
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-kr,latin1
set tenc=utf-8
set backspace=indent,eol,start
set history=10000
set tabpagemax=100
set colorcolumn=80
set signcolumn=yes
set laststatus=2
set termguicolors
set ttyfast
set title
set lazyredraw
set showcmd
set mouse=a
set cursorline
set completeopt=menuone,noinsert,noselect
set splitbelow splitright
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
set clipboard=unnamedplus
set formatoptions-=ro " You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
" or have this run as autocmd. See autocmd section.
set formatoptions+=j " Delete comment character when joining commented lines

" Show invisible characters in this format
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

" Decent wildmenu
set path+=**
set wildmenu
set wildmode=list:full
set wildignore=*.7z,*.aux,*.avi,*.bak,*.bib,*.class,*.cls,*.cmi,*.cmo,*.doc,*.docx,*.dvi,*.flac,*.flv,*.gem,*.gif,*.hi,*.ico,*.jpeg,*.jpg,*.log,*.min*.js,*.min.js,*.mov,*.mp3,*.mp4,*.mpg,*.nav,*.o,*.obj,*.ods,*.odt,*.ogg,*.opus,*.out,*.pdf,*.pem,*.png,*.rar,*.rbc,*.rbo,*.settings,*.sty,*.svg,*.swp,*.swp*.,*.tar,*.tar.bz2,*.tar.gz,*.tar.xz,*.tgz,*.toc,*.wav,*.webm,*.xcf,*.xls,*.xlsx,*.zip,*/.bundle/*,*/.sass-cache/*,*/vendor/cache/*,*/vendor/gems/*,*~,._*,.git,.hg,.svn,Thumbs.db,Zend,intermediate/*,publish/*,vendor

" This is needed to avoid swapfile warning when auto-reloading
set shortmess+=A

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

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
set noswapfile
set nobackup
set nowritebackup " writebackup can cause problems? https://github.com/sheerun/vimrc/blob/master/plugin/vimrc.vim

" Drop powershell and revert back to cmd for Windows because powershell is too
" slow and most plugins assume to use cmd in Windows

