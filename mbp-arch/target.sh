#!/usr/bin/env sh
#require: os=linux arch=x86_64 distro=arch
#description: dotfiles and packages for Intel MacBook Pro on Arch Linux

arch_pacman_extra() {
  paru ruby-fusuma
}

link_xdg_config config
require arch
step arch_pacman_extra 'flag:pkgs'
