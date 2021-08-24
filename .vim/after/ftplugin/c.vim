" it'll also be used for C++
nnoremap <buffer> <F7>   :<c-u>w|make %<<cr>
if has('unix')
    nnoremap <buffer> <C-F5> :<c-u>./%<<cr>
else
    nnoremap <buffer> <C-F5> :<c-u>%<<cr>
endif
