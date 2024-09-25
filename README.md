# dotfiles

Collection of dotfiles

## Make a directory junction in case of Windows

```cmd
mklink /j ~/.vim/vim-include .vim/vim-include
```

## File descriptions

### .vim

Folder containing vim files but I migrated to neovim

### nvim

Folder containing neovim configs  
Dependencies: git ripgrep fdfind gcc make sqlite3 msys2 pwsh  
Latter two are required for Windows only  
Powershell:

```powershell
New-Item -ItemType Junction -Path $ENV:LocalAppdata\nvim -Target nvim
```

### neovide

Neovide config.toml file for symlink  
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

### bootstrap-deb.sh

Does what Ubuntu script does in Debian but because Debian installed in WSL doesn't have wget nor curl, manually copying the script is the preferred method of installing this script

### open-webui

Linux shell script that runs open-webui related Docker images

### lsp_tests

This folder contains some sample codes to test LSP functionality
