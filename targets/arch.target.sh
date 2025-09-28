#!/usr/bin/env sh
#require: os=linux distro=arch|archarm
#description: dotfiles and packages for Arch Linux

arch_paru_install() {
  if command -v paru >/dev/null 2>&1; then
    echo "Paru already installed, skip"
    return
  fi

  sudo pacman -S base-devel git rustup --noconfirm --needed
  rustup default stable
  git clone https://aur.archlinux.org/paru.git /tmp/paru-src
  cd /tmp/paru-src
  makepkg -si
  cd -
  rm -rf /tmp/paru-src
}

arch_pacman_install() {
  pacmanfile 'packages.list'
  gsettings set org.blueman.general notification-daemon true
}

# Deps
step arch_paru_install 'flag:pkgs'
step arch_pacman_install 'flag:pkgs'

# Wallpapers
link_home 'Pictures/wallpapers' 'wallpapers'

# Configs
link_xdg_config config
