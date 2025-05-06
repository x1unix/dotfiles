#!/usr/bin/env sh
#require: os=darwin
#description: dotfiles and packages for macOS machines

darwin_brew_install() {
	brew bundle --file="$TARGET_DIR/Brewfile"
}

step darwin_brew_install 'flag:pm'
require common
link_xdg_config config

