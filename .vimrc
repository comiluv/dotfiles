" .vimrc file meant to be sourced by other IDE's vim-plugins (VSCode, etc.)
" Vim's default behavior
if &compatible
    set nocompatible
endif
" Some settings picked up from internet
set autoindent
set tabstop=8
set shiftwidth=8
set softtabstop=0
set noexpandtab
set number
set relativenumber
set wrap
set nolist
set hlsearch
set incsearch
set ignorecase
set smartcase
set scrolloff=4
set backspace=indent,eol,start
set history=10000
set laststatus=2
set showcmd
set cursorline

set clipboard=unnamed

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

" Move selected lines up and down in Visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" delete selection and put without yanking selection
vmap <leader>p "_dP

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

" 'around document' text object
onoremap ad <cmd>normal! ggVG<cr>
xnoremap ad gg0oG$

