# dotfiles

Collection of dotfiles

## Make a directory junction in case of Windows

```cmd
mklink /j ~/.vim/vim-include .vim/vim-include
```

## File descriptions

### .vim

folder containing vim files but I migrated to neovim

### nvim

folder containing neovim configs  
Powershell:

```powershell
New-Item -ItemType Junction -Path $ENV:LocalAppdata\nvim -Target nvim
```

### neovide

neovide config.toml file for symlink  
Powershell:

```powershell
New-Item -ItemType Junction -Path $ENV:Appdata\neovide -Target neovide
```

### bootstrap-ubuntu.sh

Useful Ubuntu bootstrap commands in case I reinstall wsl

```
wget https://raw.githubusercontent.com/comiluv/dotfiles/main/bootstrap-ubuntu.sh
chmod +x bootstrap-ubuntu.sh
./bootstrap-ubuntu.sh
```

### lsp_tests

This folder contains some sample codes to test LSP functionality
