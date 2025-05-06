#!/usr/bin/env sh
#require: os=linux arch=x86_64
#description: dotfiles and packages for Intel MacBook Pro on Arch Linux

arch_pacman_install() {
	sudo pacman -S \
		sway swaybg swayidle swaylock xorg-xwaylang xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk wofi waybar wl-clipboard \
		grim slurp kitty dolphin network-manager-applet networkmanager nm-connection-editor neovim neofetch git net-tools man-db gpu-switch \
		gnome-keyring blueman ttf-zed-mono-nerd zsh-syntax-highlighting zsh

	paru ruby-fusuma
}

step arch_pacman_install 'flag:pkgs'
require common
link_xdg_config config

