" .vimrc file meant to be sourced by other IDE's vim-plugins (VSCode, etc.)
" Vim's default behavior
if &compatible
    set nocompatible
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
set wrap
set linebreak
set breakindent
set nolist
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
set updatetime=50

set formatoptions-=ro " You need to make $HOME/.vim/after/ftplugin.vim and put it there to make it work
" or have this run as autocmd. See autocmd section.
set formatoptions+=j " Delete comment character when joining commented lines

" Show invisible characters in this format
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

let s:dir = has('win32') ? '$HOME/vimfiles' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let &undodir=expand(s:dir) . '/undo//'
set undofile
set noswapfile
set nobackup
set clipboard=unnamedplus

" remaps
let mapleader="\<Space>"

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
nnoremap Q gq

" Y to copy from cursor to $, as C and D
nnoremap Y y$

" n N J are centered
"nnoremap n nzzzv " found these two to be actually annoying
"nnoremap N Nzzzv
nnoremap J mzJ`z

" Easy window navigation
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

" Left and right can switch buffers
if !exists("g:vscode")
    nnoremap <left> :bp<CR>
    nnoremap <right> :bn<CR>
endif

" Move selected lines up and down in Visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" delete selection and put without yanking selection
vmap <leader>p "_dP

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Open new file adjacent to current file
" also see http://vimcasts.org/episodes/the-edit-command/ for verbose version
" also note below is taken from book Practical Vim 2nd edition which should be
" update of this remap
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
map <leader>e :e %%

" Allow for easy copying and pasting
vnoremap <silent> y y`]
nnoremap <silent> p p`]
nnoremap <silent> P P`]

" Visually select the text that was last edited/pasted (Vimcast#26).
noremap gV `[v`]

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" fix & command Practical Vim tip 93
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" replace whatever was on the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

