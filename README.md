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

### efm-langserver

folder containing efm language server configs
Powershell:

```powershell
New-Item -ItemType Junction -Path $ENV:Appdata\efm-langserver -Target efm-langserver
```

### setup.sh

Useful Ubuntu bootstrap commands in case I reinstall wsl
