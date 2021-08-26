" it'll also be used for C++
nnoremap <buffer> <F5> :<C-u>w!<bar>!make %<<CR>
if has('unix')
    nnoremap <buffer> <F8> :<C-u>term ./%<<CR>
else
    nnoremap <buffer> <F8> :<C-u>term %<<CR>
endif
