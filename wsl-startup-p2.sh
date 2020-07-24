#!/bin/bash
set -euo pipefail

echo "Compiling italic terminfo"
tic terminfo-italic-fix/screen-256color-italic
tic terminfo-italic-fix/xterm-256color-italic
tic terminfo-italic-fix/tmux-256color
tic terminfo-italic-fix/tmux-256color-italic
echo

echo "Setting up nameserver"
sudo rm -f /etc/resolv.conf
printf "nameserver 8.8.8.8\n" | sudo tee /etc/resolv.conf > /dev/null
echo

echo "Installing apt packages"
sudo apt update
sudo apt upgrade
sudo apt install tmux zsh build-essential libncursesw5-dev pkg-config fzf
echo

if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p $HOME/.local/bin
fi
if [ ! -f "$HOME/.z" ]; then
    touch $HOME/.z
fi
if [ ! -d "$HOME/.oh-my-zsh/" ]; then
    echo "Installing oh-my-zsh"
    echo "After installation is done, press <C-d>."
    sleep 3
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [ ! -f "$HOME/.local/bin/kak" ]; then
    echo "Installing Kakoune"
    git clone https://github.com/mawww/kakoune $HOME/kakoune-src
    pushd $HOME/kakoune-src/src
    make
    make man
    PREFIX=$HOME/.local make install
    popd
fi

if [ ! -f "$HOME/.dotfiles-done" ]; then
    echo "Copying over dotfiles"
    cp -R dotfiles/. $HOME/
fi

if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
    echo "Installing Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o $HOME/.local/bin/rust-analyzer
    chmod +x $HOME/.local/bin/rust-analyzer
    $HOME/.cargo/bin/cargo install voidmap
    $HOME/.cargo/bin/cargo install exa
fi

if [ ! -d "$HOME/.config/kak/plugins" ]; then
    echo "Installing Kakoune plugins"
    mkdir -p $HOME/.config/kak/plugins
    git clone https://github.com/andreyorst/plug.kak.git $HOME/.config/kak/plugins/plug.kak
    echo "Starting Kakoune. Please run :plug-install, and once all plugins have finished installing, quit Kakoune."
    sleep 3
    $HOME/.local/bin/kak
fi

echo "Installing X server"
scoop install vcxsrv
sudo apt install x11-apps
xlaunch.exe
export DISPLAY=`netsh.exe interface ip show ipaddresses "vEthernet (WSL)" | head -n 2 - | tail -n 1 | awk '{ print $2; }'`:0.0
xeyes&

if [ ! -d "$HOME/.gnupg" ]; then
    echo "Where to import GPG key from? Leave empty to generate new key."
    read gpgimport
    if [ -z "$gpgimport" ]; then
        echo "Generating new key."
        echo "Please don't press while producing entropy."
        gpg --generate-key

        echo "Please press enter."
        read # The user may have written characters to the terminal while creating entropy for GPG.
    else
    	echo "Importing key."
        gpg --import "$gpgimport"
    fi
fi

if [ ! -d "$HOME/.ssh" ]; then
    echo "Where to import SSH key data from? Leave empty to generate new keypair."
    read sshimport
    if [ -z "$sshimport" ]; then
        echo "Generating new keypair."
        ssh-keygen -t ed25519 -a 100
    else
        echo "Importing key data."
        cp -R "$sshimport" $HOME/.ssh
        chmod -R 700 $HOME/.ssh
    fi
fi

if [ -z "`git config --global --get user.email`" ]; then
    echo "Configuring Git."
    echo "Email:"
	read gitemail
	git config --global user.email "$gitemail"
	echo "Name:"
	read gitname
	git config --global user.name "$gitname"

	echo "Available secret keys:"
	gpg --list-secret-keys --keyid-format LONG
	echo "Please input the desired secret key"
	read gitkey
	git config --global user.signingkey "$gitkey"
	git config --global commit.gpgsign true
fi
