#!/usr/bin/env sh
#require: os=darwin
#description: dotfiles and packages for macOS machines

darwin_brew_install() {
  brewfile 'Brewfile'
}

step darwin_brew_install 'flag:pkgs'
require common
link_xdg_config config
