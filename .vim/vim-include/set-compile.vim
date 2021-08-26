" To make sure to compile with warnings and in C++17
" You don't need anything else
let $CXXFLAGS='-g -W -Wall -Wextra -Werror -pedantic -std=c++17'
" and don't forget warnings in C either
let $CFLAGS='-g -W -Wall -Wextra -Werror -pedantic'

" C++ header folder for the book PPAPUCPP
let $CPLUS_INCLUDE_PATH.=expand('$HOME/ppapucpp/Programming-_Principles_and_Practice_Using_Cpp')
