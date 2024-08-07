#!/usr/bin/sh

# make sure to chmod +x filename

# disabling password
username=$(whoami)
# add the username to a sudo config file
temp=$(mktemp)
printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$username" > $temp
chmod 644 $temp
sudo cp $temp /etc/sudoers.d/$username

cd ~

# install locale
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Update server to use Kakao mirror (!UNOFFICIAL MIRROR!)
sudo sed -i 's/archive\.ubuntu\.com/mirror\.kakao\.com/g' /etc/apt/sources.list

# make some dirs
mkdir -p ~/.local/bin
mkdir ~/.config
mkdir ~/bin

# setup git
echo Input git username
read gitname
echo Input git email
read gitemail
git config --global user.name $gitname
git config --global user.email $gitemail
# assume git is installed using installer from https://git-scm.com/downloads
git config --global credential.helper "mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global core.editor "nvim"

# setup vim
git clone https://github.com/comiluv/dotfiles ~/dotfiles
ln -s ~/dotfiles/.vim ~/.config/.vim
ln -s ~/dotfiles/nvim ~/.config/nvim
touch ~/.vimrc
echo 'source ~/.config/.vim/vimrc' >> ~/.vimrc

# Add git ppa repo
sudo add-apt-repository ppa:git-core/ppa -y

# Update packages
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y

# Install most softwares
sudo apt install gcc g++ gdb make gpg unzip fd-find ripgrep bat zsh jq python3-pip libfuse2 -y

# Install neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

# setup some symlinks
ln -s $(which fdfind) ~/.local/bin/fd
ln -s /bin/batcat ~/.local/bin/bat

# use Windows Explorer with ii
ln -s /mnt/c/Windows/explorer.exe ~/.local/bin/ii

# install tree-sitter
curl -Lo tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
gunzip tree-sitter.gz
sudo install tree-sitter /usr/local/bin
rm tree-sitter

# install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
rm lazygit.tar.gz
sudo install lazygit /usr/local/bin
rm lazygit

# install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt install -y eza

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# user aliases for sudo and neovim
printf "\n# sudo aliases with sudo\nalias sudo='sudo '\n# neovim\nalias v='~/nvim.appimage '\n" >> ~/.zshrc

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install eza completions
git clone https://github.com/eza-community/eza.git ~/eza
echo '\n# Eza completions\nexport FPATH="~/eza/completions/zsh:$FPATH"\n' >> ~/.zshrc

# eza aliases
printf "\n#Eza aliases\nalias ld='eza -lD'\nalias lf='eza -lF --color=always | grep -v /'\nalias lh='eza -dl .* --group-directories-first'\nalias ll='eza -al --group-directories-first'\nalias ls='eza -alF --color=always --sort=size'\nalias lt='eza -al --sort=modified'\nalias l='eza -lah'\nalias la='eza -lAh'\nalias lsa='eza -lah'\n" >> ~/.zshrc

# configure .zshrc
printf "\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/bin\" ] ; then\n PATH=\"\$HOME/bin:\$PATH\"\n fi\n\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/.local/bin\" ] ; then\n PATH=\"\$HOME/.local/bin:\$PATH\"\n fi\n" >> ~/.zshrc

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# temporarily remove Windows path from wsl
# see https://stackoverflow.com/questions/51336147/how-to-remove-the-win10s-path-from-wsl
PATH=$(/usr/bin/printenv PATH | /usr/bin/perl -ne 'print join(":", grep { !/\/mnt\/[a-z]/ } split(/:/));')

# Install zsh-nvm
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

sed -i 's/plugins=(git)/plugins=(zsh-nvm git zsh-autosuggestions)/g' ~/.zshrc

chsh -s /bin/zsh
zsh

