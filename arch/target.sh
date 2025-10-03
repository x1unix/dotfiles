#!/usr/bin/env sh
#require: os=linux distro=arch|archarm
#description: dotfiles and packages for Arch Linux

arch_pacman_install() {
  pacmanfile 'packages.list'

  rustup default stable
  aurpkg 'paru'

  gsettings set org.blueman.general notification-daemon true
}

# Deps
step arch_pacman_install 'flag:pkgs'

# Wallpapers
link_home 'Pictures/wallpapers' 'wallpapers'

# Configs
link_xdg_config config
