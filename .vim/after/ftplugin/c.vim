setlocal tabstop=8 shiftwidth=2 softtabstop=2 expandtab
" it'll also be used for C++
nnoremap <buffer> <F5> :<C-u>cd %:p:h<BAR>:w!<BAR>!make %<<CR>
imap <F5> <ESC><F5>
vmap <F5> <ESC><F5>
if has('win32')
    nnoremap <buffer> <F8> :<C-u>cd %:p:h<BAR>:term %<<CR>
else
    nnoremap <buffer> <F8> :<C-u>cd %:p:h<BAR>:term ./%<<CR>
endif
imap <F8> <ESC><F8>
vmap <F8> <ESC><F8>

" To make sure to compile with warnings and in C++17
" You don't need anything else
let $CXXFLAGS='-g -W -Wall -Wextra -pedantic -std=c++17'
" and don't forget warnings in C either
let $CFLAGS='-g -W -Wall -Wextra -pedantic'

" C++ header folder for the book PPAPUCPP
let $CPLUS_INCLUDE_PATH.=expand('$HOME/ppapucpp/Programming-_Principles_and_Practice_Using_Cpp')

