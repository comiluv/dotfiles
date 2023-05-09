" from https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
    set grepprg=rg\ --no-heading\ --color\ never\ --vimgrep\ --iglob\ !/.git/
    set grepformat=%f:%l:%c:%m
    let g:rg_derive_root='true'
endif

