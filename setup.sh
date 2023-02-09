#!/usr/bin/sh

# make sure to run this script as user after doing chmod +x filename
cd ~

# install locale
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Update mirror to use Kakao server
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
sudo apt install gcc g++ gdb python3-pip python3-venv neovim unzip fd-find ripgrep silversearcher-ag bat zsh jq fortune-mod -y

# Install neo-cowsay
wget https://github.com/Code-Hex/Neo-cowsay/releases/download/v2.0.4/Neo-cowsay_2.0.4_linux_amd64.deb
sudo apt install ./Neo-cowsay_2.0.4_linux_amd64.deb
rm Neo-cowsay_2.0.4_linux_amd64.deb

# Install fd
ln -s $(which fdfind) ~/.local/bin/fd

# use Windows Explorer with ii
ln -s /mnt/c/Windows/explorer.exe ~/.local/bin/ii

# install tree-sitter
curl -Lo tree-sitter.gz "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
gunzip tree-sitter.gz
sudo install tree-sitter /usr/local/bin
rm tree-sitter

#install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
rm lazygit.tar.gz
sudo install lazygit /usr/local/bin
rm lazygit

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# configure .zshrc
printf "\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/bin\" ] ; then\n PATH=\"\$HOME/bin:\$PATH\"\n fi\n\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/.local/bin\" ] ; then\n PATH=\"\$HOME/.local/bin:\$PATH\"\n fi\n\nalias v='nvim'\n" >> ~/.zshrc

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

