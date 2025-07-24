#!/usr/bin/env sh
#require: os=linux arch=x86_64 distro=arch
#description: dotfiles and packages for Arch Linux

arch_paru_install() {
	if command -v paru >/dev/null 2>&1; then
		echo "Paru already installed, skip"
		return
	fi

	sudo pacman -S base-devel git rustup --noconfirm
	rustup default stable
	git clone https://aur.archlinux.org/paru.git /tmp/paru-src
	cd /tmp/paru-src
	makepkg -si
	cd -
	rm -rf /tmp/paru-src
}

arch_pacman_install() {
	sudo pacman -S \
		stow sway swaybg swayidle swaylock xorg-xwaylang xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk wofi waybar wl-clipboard \
		grim slurp kitty dolphin network-manager-applet networkmanager nm-connection-editor neovim neofetch git net-tools man-db \
		gnome-keyring polkit-gnome blueman ttf-zed-mono-nerd zsh-syntax-highlighting zsh lazygit

	paru ruby-fusuma
}

step arch_paru_install 'flag:pkgs'
step arch_pacman_install 'flag:pkgs'
require common
link_xdg_config config

