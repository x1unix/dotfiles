#!/usr/bin/env sh
#require: os=linux arch=x86_64 distro=arch
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
	sudo pacman -S \
		sway swaybg swayidle swaylock dunst xorg-xwayland xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk gnome-keyring polkit-gnome blueman ttf-zed-mono-nerd \
		stow wofi waybar wl-clipboard alacritty ghostty grim slurp kitty dolphin network-manager-applet networkmanager nm-connection-editor \
    zsh-syntax-highlighting zsh lazygit neovim git net-tools man-db lf nodejs npm go \
    --needed --noconfirm

  gsettings set org.blueman.general notification-daemon true
}

step arch_paru_install 'flag:pkgs'
step arch_pacman_install 'flag:pkgs'
require common
link_xdg_config config

