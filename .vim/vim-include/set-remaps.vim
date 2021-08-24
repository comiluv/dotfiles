" Remaps for plugins are inside individual set-pluginname.vim files

let mapleader="\<Space>"

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Remap Alt key combinations to M combinations in wsl2 / Ubuntu
" https://github.com/vim/vim/issues/8726
if has('unix') && !has('nvim') " Only works in unix (and not in Windows) Vim and neoVim doesn't need this
    execute "set <M-e>=\<Esc>e"
    execute "set <M-p>=\<Esc>p"
    execute "set <M-n>=\<Esc>n"
    execute "set <M-b>=\<Esc>b"
    execute "set <M-j>=\<Esc>j"
    execute "set <M-k>=\<Esc>k"
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" Y to copy from cursor to $, as C and D
nmap Y y$

" n N J are centered
"nnoremap n nzzzv " found these two to be actually annoying
"nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo breakpoints
inoremap , ,<C-G>u
inoremap . .<C-G>u
inoremap ! !<C-G>u
inoremap ? ?<C-G>u

" Undo breakpoints for C-U and C-W in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Allow easy navigation between wrapped lines.
" Merged this to jumplist modification below
"nmap j gj
"nmap k gk
vnoremap j gj
vnoremap k gk

" Easy window navigation
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Jumplist mutations for k and j
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'gk'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'gj'

" Conveniently move lines up and down with ctrl+j and ctrl+k
"nnoremap <C-j> :m .+1<CR>==
"nnoremap <C-k> :m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Use <Tab> and <S-Tab> to navigate through popup menu and <Enter> to select
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" To avoid conflict with vim-endwise, use functions - see: https://github.com/tpope/vim-endwise/issues/105
function! SendCY()
    call feedkeys("\<C-Y>", "t")
    return ""
endfunction
function! SendCR()
    call feedkeys("\<C-g>u\<CR>", "n")
    return ""
endfunction
if has('patch8.1.1068')
    " Use `complete_info` if your (Neo)Vim version supports it.
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? SendCY() : SendCR()
else
    imap <expr> <cr> pumvisible() ? SendCY() : SendCR()
endif

" delete selection and put without yanking selection
vmap <leader>p "_dP

" yank to clipboard
nmap <leader>y "+y
vmap <leader>y "+y
nmap <leader>Y gg"+yG

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Open new file adjacent to current file
" also see http://vimcasts.org/episodes/the-edit-command/ for verbose version
" also note below is taken from book Practical Vim 2nd edition which should be
" update of this remap
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
map <leader>e :e %%

" Prevent common mistake of pressing q: instead :q
"map q: :q

" Allow for easy copying and pasting
vnoremap <silent> y y`]
nnoremap <silent> p p`]
nnoremap <silent> P P`]

" Visually select the text that was last edited/pasted (Vimcast#26).
noremap gV `[v`]

" Auto-fix typo in command mode: Don't try to be perfect, adjust your tool to
" help you not the other way around. : https://thoughtbot.com/upcase/vim
command! Q q " Bind :Q to q
command! Qall qall
command! QA qall

" Disable 'press :qa to exit' messages
nnoremap <C-c> <silent> <C-c>

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Default to 'very magic' regex search
" https://vim.fandom.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/
nnoremap :g/ :g/\v
nnoremap :g// :g//
