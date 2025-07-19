set -o vi

export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"

alias ..='cd ..'
alias ll='ls -la'
alias apti='sudo apt install'
alias apts='apt search'
alias nv='nvim'
alias tailf='tail -f'
alias arch='proot-distro login --user x1unix archlinux'
alias archr='proot-distro login archlinux'
alias md='mkdir'

mcd() {
  mkdir "$1" && cd "$1"
}

# linuxbrew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

