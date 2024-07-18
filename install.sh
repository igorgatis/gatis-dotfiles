#!/bin/bash
set -x
cd ~/

ln -sf dotfiles/.bashrc
ln -sf dotfiles/.gitconfig
ln -sf dotfiles/.tmux.conf
ln -sf dotfiles/.vimrc
ln -sf dotfiles/bin

osname=$(uname)
if [ "$osname" == "Darwin" ]; then
  chsh -s /bin/bash
  ln -sf dotfiles/.bash_profile
fi

