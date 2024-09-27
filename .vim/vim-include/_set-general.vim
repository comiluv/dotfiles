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
" Reload buffer if its changed outside of Vim
set autoread
set autoindent
set smarttab
set smartindent
set number relativenumber
set nrformats-=octal
set wrap breakindent
" Better search options
set hlsearch incsearch ignorecase smartcase
" Scroll vertically and horizontally
set scrolloff=4 sidescroll=1 sidescrolloff=4
set display+=truncate
set hidden
set ruler
" Modern encoding rules
set encoding=utf-8 fileencodings=ucs-bom,utf-8,euc-kr,latin1 tenc=utf-8
set backspace=indent,eol,start
" Disable completing keywords in included files (e.g., #include in C).  When
" configured properly, this can result in the slow, recursive scanning of
" hundreds of files of dubious relevance.
set complete-=i
set history=1000
set tabpagemax=100
" Set 'textwidth' and set 'colorcolumn' relative to 'textwidth', only when needed
set signcolumn=yes
set laststatus=2
set termguicolors
set title
set mouse=a
set completeopt=menuone,noinsert,noselect
set splitbelow splitright
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
set clipboard=unnamedplus
set formatoptions-=ro " You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
" or have this run as autocmd. See autocmd section.
set formatoptions+=j " Delete comment character when joining commented lines

" Show invisible characters in this format
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

" Decent wildmenu https://youtu.be/XA2WjJbmmoM
set path+=**
set wildmenu
set wildmode=list:full
set wildignore=*.7z,*.aux,*.avi,*.bak,*.bib,*.class,*.cls,*.cmi,*.cmo,*.doc,*.docx,*.dvi,*.flac,*.flv,*.gem,*.gif,*.hi,*.ico,*.jpeg,*.jpg,*.log,*.min*.js,*.min.js,*.mov,*.mp3,*.mp4,*.mpg,*.nav,*.o,*.obj,*.ods,*.odt,*.ogg,*.opus,*.out,*.pdf,*.pem,*.png,*.rar,*.rbc,*.rbo,*.settings,*.sty,*.svg,*.swp,*.swp*.,*.tar,*.tar.bz2,*.tar.gz,*.tar.xz,*.tgz,*.toc,*.wav,*.webm,*.xcf,*.xls,*.xlsx,*.zip,*/.bundle/*,*/.sass-cache/*,*/vendor/cache/*,*/vendor/gems/*,*~,._*,.git,.hg,.svn,Thumbs.db,Zend,intermediate/*,publish/*,vendor

" This is needed to avoid swapfile warning when auto-reloading
set shortmess+=A

" Make the escape key more responsive by decreasing the wait time for an
" escape sequence (e.g., arrow keys).
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" from vim-sensible by tpope. see :h file-searching:
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
if !empty(&viminfo)
  set viminfo^=!
endif

" Saving options in session and view files causes more problems than it
" solves, so disable it.
set sessionoptions-=options
set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Disable a legacy behavior that can break plugin maps.
if has('langmap') && exists('+langremap') && &langremap && s:MaySet('langremap')
  set nolangremap
endif

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif

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
    " Enable undofile and set undodir and backupdir for vim - neovim has default locations
    " https://neovim.io/doc/user/vim_diff.html#vim-differences
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

" Drop powershell and revert back to cmd for Windows because powershell is too
" slow and most plugins assume to use cmd in Windows

