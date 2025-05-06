#!/usr/bin/env sh
#description: common dotfiles

install_shmgr() {
	if ! grep -q '~/.config/shell/loader.sh' ~/.zshrc; then
		echo '[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh' >> ~/.zshrc
	else 
		echo 'shmgr autoload already installed, skip'
	fi

	"$HOME/.local/bin/shmgr" gen
}

install_tpm() {
	if [ ! -d ~/.tmux/plugins/tpl ]; then
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	else
		echo "tpm already installed, skip"
	fi

	echo 'installing tpm plugins...'
  $HOME/.tmux/plugins/tpm/bin/install_plugins
}

install_tpm_rollback() {
	rm -rf "$HOME/.tmux/plugins/tpm"
}

install_vim_plug() {
	plug_file="${XDG_DATA_HOME}/nvim/site/autoload/plug.vim"
	plug_src='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	if [ ! -f "$plug_file" ]; then
		sh -c "curl -fLo '$plug_file' --create-dirs '$plug_src'"
	else
		echo 'vim-plug already installed'
	fi

	echo 'installing vim-plug packages...'
	nvim -es -u "$TARGET_DIR/config/nvim/init.vim" -i NONE -c 'PlugInstall' -c 'qa'
}

install_ssh_config() {
	mkdir -p ~/.ssh

	include_dir="${TARGET_DIR#"$HOME"}"
	include_dir="~$include_dir"

	ssh_include="Include \"$include_dir/ssh_config\""
	if ! grep -q "$ssh_include" ~/.ssh/config; then
		echo "$ssh_include" >> ~/.ssh/config
	else
		echo 'ssh config already updated'
	fi
}

# Mount all dotfiles in common/dotfiles
link_home dotfiles

# common/bin to ~/.local/bin
link_local_bin bin

# Mount emacs config to ~/.emacs.d
link_home '.emacs.d' emacs

# Mount ~/.config
link_xdg_config config

step install_vim_plug 'flag:vim'
step install_shmgr 'flag:shmgr'
step install_tpm 'flag:tpm'
step install_ssh_config

