#!/usr/bin/env sh
#require: os=linux distro=android
#description: dotfiles and packages for Termux environment

termux_init_bashrc() {
  if ! grep -q '.bash_aliases' ~/.bashrc; then
    echo 'ALIASES=$HOME/.bash_aliases' >>"$HOME/.bashrc"
    echo 'if [ -f "$ALIASES" ]; then' >>"$HOME/.bashrc"
    echo '  . "$ALIASES"' >>"$HOME/.bashrc"
    echo 'fi' >>"$HOME/.bashrc"
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
  props="$HOME/.termux/termux.properties"
  if [ -e "$props" ] && [ ! -L "$props" ]; then
    rm -f ~/.termux/termux.properties
  fi
}

step termux_init_home
step termux_init_bashrc
aptfile 'packages.list'

# Mount Termux config to ~/.termux
link_home '.termux' termux
link_home '.gnupg' dot_gnupg

require common

# Link .bashrc
link_home dotfiles
