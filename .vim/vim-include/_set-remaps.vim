" Remaps for plugins are inside individual set-pluginname.vim files

let mapleader="\<Space>"
nnoremap <leader>pv <CMD>Ex<CR>

" Remap Alt key combinations to M combinations in wsl2 / Ubuntu
" https://github.com/vim/vim/issues/8726
if has('unix') && !has('nvim') " Only works in unix Vim (and not in Windows) and neoVim doesn't need this
    execute "set <M-e>=\<Esc>e"
    execute "set <M-p>=\<Esc>p"
    execute "set <M-n>=\<Esc>n"
    execute "set <M-b>=\<Esc>b"
    execute "set <M-h>=\<Esc>h"
    execute "set <M-j>=\<Esc>j"
    execute "set <M-k>=\<Esc>k"
    execute "set <M-l>=\<Esc>l"
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
nnoremap Q gq

" Y to copy from cursor to $, as C and D
nnoremap Y y$

" n N J are centered
"nnoremap n nzzzv " found these two to be actually annoying
"nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo breakpoints for C-U and C-W in insert mode
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Easy window navigation
noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

" Left and right can switch buffers
nnoremap <left> <CMD>bp<CR>
nnoremap <right> <CMD>bn<CR>

" Jumplist mutations + easy navigation in wrapped lines for k and j
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : v:count1 == 1 ? "g" : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : v:count1 == 1 ? "g" : "") . 'j'

" Move selected lines up and down in Visual mode
vnoremap J <CMD>m '>+1<CR>gv=gv
vnoremap K <CMD>m '<-2<CR>gv=gv

" Use <Tab> and <S-Tab> to navigate through popup menu and <Enter> to select
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
if has('patch8.1.1068')
    " Use `complete_info` if your (Neo)Vim version supports it.
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
endif

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

" prevent common mistake of pressing q: instead of :q
nnoremap q: :q

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

" fix & command Practical Vim tip 93
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" replace whatever was on the cursor
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" open help about word on cursor by pressing <F1>
nnoremap <F1> <CMD>help <C-r><C-w><CR>
cmap <F1> <ESC><F1>
imap <F1> <ESC><F1>
vmap <F1> <ESC><F1>

" 'around document' text object
onoremap ad <CMD>normal! ggVG<CR>
xnoremap ad gg0oG$

