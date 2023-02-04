" it'll also be used for C++
nnoremap <buffer> <F5> :<C-u>w!<bar>!make %<<CR>
imap <F5> <ESC><F5>
vmap <F5> <ESC><F5>
if has('win32')
    nnoremap <buffer> <F8> :<C-u>term %<<CR>
else
    nnoremap <buffer> <F8> :<C-u>term ./%<<CR>
endif
imap <F8> <ESC><F8>
vmap <F8> <ESC><F8>
