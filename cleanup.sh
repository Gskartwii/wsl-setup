#!/bin/bash
set -euo pipefail

sudo usermod -s /bin/bash `whoami`

if [ -f /etc/wsl.conf ]; then
	sudo rm /etc/wsl.conf
fi
if [ -f /etc/resolv.conf ]; then
	sudo rm /etc/resolv.conf
fi
sudo apt purge tmux zsh build-essential libncursesw5-dev pkg-config x11-apps fzf
sudo apt autoremove

rm -rf $HOME/.local/bin $HOME/.z $HOME/.oh-my-zsh $HOME/.config $HOME/.local $HOME/.cargo $HOME/.gpg $HOME/ssh $HOME/kakoune-src
rm -f $HOME/.dotfiles-done $HOME/.tmux.conf $HOME/.tmux.conf.local $HOME/.zshrc
