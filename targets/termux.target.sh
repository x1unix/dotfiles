#!/usr/bin/env sh
#require: os=linux distro=android
#description: dotfiles and packages for Termux environment

termux_pkg_install() {
  pkg install -y \
    x11-repo termux-tools termux-services unzip which build-essential pinentry \
    inetutils htop iproute2 lsof net-tools nmap \
    tmux proot-distro sed stow git openssh fzf ripgrep \
    neovim zsh rust stylua nodejs golang lua-language-server rust-analyzer lazygit
}

termux_init_bashrc() {
  if ! grep -q '.bash_aliases' ~/.bashrc; then
    echo 'ALIASES=$HOME/.bash_aliases' >> "$HOME/.bashrc"
    echo 'if [ -f "$ALIASES" ]; then' >> "$HOME/.bashrc"
    echo '  . "$ALIASES"' >> "$HOME/.bashrc"
    echo 'fi' >> "$HOME/.bashrc"
	else 
		echo '.bash_aliases already installed, skip'
	fi
}

termux_init_home() {
  mkdir -p "$HOME/.local/bin"
  if [ ! -d ~/storage ]; then
    termux-setup-storage
  fi

  # To avoid conflicts with stow
  rm -f ~/.termux/termux.properties
}

step termux_init_home
step termux_init_bashrc
step termux_pkg_install 'flag:pkgs'

require common

# Link .bashrc
link_home dotfiles

# Mount Termux config to ~/.termux
link_home '.termux' termux

