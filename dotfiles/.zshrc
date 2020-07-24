ZSH=$HOME/.oh-my-zsh
CASE_SENSITIVE="true"
export PATH="/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH"
export MANPATH="/usr/local/man/:$HOME.local/share/man/:$MANPATH"
ZSH_THEME="gnzh"
plugins=(git ssh-agent gpg-agent z)

source $ZSH/oh-my-zsh.sh

alias tm="tmux attach || tmux new-session"
export EDITOR=kak
export GOPATH=$HOME/go
export BROWSER=x-www-browser
export DISPLAY=`netsh.exe interface ip show ipaddresses "vEthernet (WSL)" | head -n 2 - | tail -n 1 | awk '{ print $2; }'`:0.0
