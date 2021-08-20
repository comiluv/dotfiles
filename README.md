# dotfiles
Collection of dotfiles

```
yadm clone --bootstrap https://www.github.com/comiluv/dotfiles
```

## Make a directory junction in case of Windows

```cmd
mklink /j ~/.vim/vim-include .vim/vim-include
```

## File descriptions
### .config/yadm
[yadm](yadm.io) [bootstrap](https://yadm.io/docs/bootstrap) file
### .vim/vimrc
a vimrc file
### .zshrc
a zshrc file
### .zshenv
zsh aliases and other misc settings
### .p10k.zsh
a powerlevel10k theme file
### ginit.vim
```cmd
mklink /h %localappdata%\nvim\ginit.vim ginit.vim
```
