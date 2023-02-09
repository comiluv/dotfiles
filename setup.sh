#!/usr/bin/bash

# make sure to run this script as user after doing chmod +x filename
cd ~

# install locale
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Update mirror to use Kakao server
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

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
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

# setup vim
git clone https://github.com/comiluv/dotfiles ~/dotfiles
ln -s ~/dotfiles/.vim ~/.config/.vim
ln -s ~/dotfiles/nvim ~/.config/nvim
touch ~/.vimrc
echo 'source ~/.config/.vim/vimrc' >> ~/.vimrc

# Add git ppa repo
sudo add-apt-repository ppa:git-core/ppa -y

# Add python3 ppa repository
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Add vim ppa repo
sudo add-apt-repository ppa:jonathonf/vim -y

# Add neovim ppa repo
sudo add-apt-repository ppa:neovim-ppa/unstable -y

# Update packages
sudo apt update && sudo apt upgrade -y

# Install most softwares
sudo apt install gcc g++ gdb python3-pip python3-venv neovim unzip fd-find ripgrep zsh jq fortune-mod -y

# Install neo-cowsay
wget https://github.com/Code-Hex/Neo-cowsay/releases/download/v2.0.4/Neo-cowsay_2.0.4_linux_amd64.deb
sudo apt install ./Neo-cowsay_2.0.4_linux_amd64.deb
rm Neo-cowsay_2.0.4_linux_amd64.deb

# Install fd
ln -s $(which fdfind) ~/.local/bin/fd

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# configure .zshrc
printf "\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/bin\" ] ; then\n PATH=\"\$HOME/bin:\$PATH\"\n fi\n\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/.local/bin\" ] ; then\n PATH=\"\$HOME/.local/bin:\$PATH\"\n fi\n" >> ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

