" it'll also be used for C++
nnoremap <buffer> <F7> :<C-u>w!<bar>!make %<<CR>
if has('unix')
    nnoremap <buffer> <C-F5> :<C-u>!./%<<CR>
else
    nnoremap <buffer> <C-F5> :<C-u>!%<<CR>
endif
