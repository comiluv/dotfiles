#!/bin/sh

# make sure to chmod +x filename

# Execution tracing
set -xe

# disabling password
username=$(id -un)
# add the username to a sudo config file
temp=$(mktemp)
printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$username" > $temp
chmod 644 $temp
sudo cp $temp /etc/sudoers.d/$username

cd ~

# install locale
sudo locale-gen "en_US.UTF-8"
sudo update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX
sudo dpkg-reconfigure locales

# Update server to use Kaist mirror
sudo sed -i.bak 's/\(archive\|security\)\.ubuntu\.com/ftp.kaist.ac.kr/g' /etc/apt/sources.list

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
git config --global init.defaultbranch "main"

git clone https://github.com/comiluv/dotfiles ~/dotfiles

# setup vim
mkdir -p ~/.vim
# Loop over each item in the dotfiles/.vim directory
for item in ~/dotfiles/.vim/*; do
	# Get the base name of the file or directory
	base_item=$(basename "$item")
	# Create a symbolic link in the destination directory
	ln -sf "$item" ~/.vim/"$base_item"
done
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Add git ppa repo
sudo add-apt-repository ppa:git-core/ppa -y

# Update packages
sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y

# Install most softwares
sudo apt install build-essential gcc g++ gdb make gpg unzip fd-find ripgrep bat zsh jq python3-pip xclip sqlite3 libsqlite3-dev tealdeer anacron -y

# Install nerd fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/D2Coding.tar.xz
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.tar.xz
sudo mkdir -p /usr/share/fonts/DejaVuSansMono
sudo mkdir -p /usr/share/fonts/d2coding
sudo tar xf DejaVuSansMono.tar.xz --directory=/usr/share/fonts/DejaVuSansMono
sudo tar xf D2Coding.tar.xz --directory=/usr/share/fonts/d2coding
rm DejaVuSansMono.tar.xz
rm D2Coding.tar.xz
sudo fc-cache -f

# Install volta
curl https://get.volta.sh | bash

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/

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

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# path and user aliases for sudo and neovim
printf "\n# sudo aliases with sudo\nalias sudo='sudo '\n# neovim\nalias v='/usr/local/bin/nvim '\n" >> ~/.zshrc

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# configure .zshrc
printf "\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/bin\" ] ; then\n PATH=\"\$HOME/bin:\$PATH\"\n fi\n\n# set PATH so it includes user's private bin if it exists\n if [ -d \"\$HOME/.local/bin\" ] ; then\n PATH=\"\$HOME/.local/bin:\$PATH\"\n fi\n" >> ~/.zshrc

# configure bat colorscheme to Monokai Extended Light
echo '\nexport BAT_THEME="Monokai Extended Light"\n' >> ~/.zshrc

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

chsh -s /bin/zsh
zsh

