#!/bin/bash
sudo apt-get update
sudo apt-get upgrade

# Installing some useful libraries
sudo apt-get install clang libclang-dev libclang1

# Installing apps
sudo apt-get install xorg awesome slim ranger zsh tmux rxvt-unicode-256color vlc scrot kolourpaint4 nasm g++ gpicview evince unrar xscreensaver xscreensaver-gl w3m mutt newsbeuter

# Installing vim
sudo apt-get install vim-gnome vim-youcompleteme vim-addon-manager

# Installing latex
sudo apt-get install texmaker texlive-lang-portuguese texlive-fonts-recommended texlive-science

# Installing codecs and extras
sudo apt-get install libav-tools ttf-mscorefonts-installer alsa-firmware-loaders libavcodec-extra57

# Configuring dotfiles
cp -rl zsh/.zsh ~/.zsh
cp -rl awesome ~/.config/awesome
cp -rl vim/.vim ~/.vim
cp -rl urxvt/.urxvt ~/.urxvt
cp -rl ranger ~/.config/ranger
cp -rl mutt/.mutt ~/.mutt
cp -rl newsbeuter/.newsbeuter ~/.newsbeuter

ln zsh/.zshrc ~/.zshrc
ln vim/.vimrc ~/.vimrc
ln vimperator/.vimperatorrc ~/.vimperatorrc
ln bash/.bashrc ~/.bashrc
ln bash/.inputrc ~/.inputrc
ln tmux/.tmux.conf ~/.tmux.conf
ln urxvt/.Xresources ~/.Xresources
ln mutt/.muttrc ~/.muttrc

# Configuring slim
sudo cp -rl slim/obscur /usr/share/slim/themes
sudo cp -rl slim/slim.conf /etc/slim.conf

# Installing awesomewm required libraries
sudo cp -rf lib /usr/share/awesome/

# Configuring zsh
chsh -s $(which zsh)

# Configuring vim autocomplete
vam install youcompleteme

# Configuring mutt
touch ~/.mutt/certificates
mkdir ~/.mutt/cache
mkdir ~/.mutt/cache/bodies
mkdir ~/.mutt/cache/headers
mkdir ~/.mutt/cache/news
mkdir ~/.mutt/tmp
