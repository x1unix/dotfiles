#!/usr/bin/env sh
#description: common dotfiles

install_shmgr() {
  if ! grep -q '~/.config/shell/loader.sh' ~/.zshrc; then
    echo '[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh' >>~/.zshrc
  else
    echo 'shmgr autoload already installed, skip'
  fi

  "$HOME/.local/bin/shmgr" gen
}

install_tpm() {
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    echo "tpm already installed, skip"
  fi

  echo 'installing tpm plugins...'
  export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
  $HOME/.tmux/plugins/tpm/bin/install_plugins
}

install_tpm_rollback() {
  rm -rf "$HOME/.tmux/plugins/tpm"
}

# Mount all dotfiles in common/dotfiles
link_home dotfiles

# common/bin to ~/.local/bin
link_local_bin bin

# Mount emacs config to ~/.emacs.d
link_home '.emacs.d' emacs

# Mount ~/.config
link_xdg_config config

step install_shmgr 'flag:shmgr'
step install_tpm 'flag:tpm'

# Install SSH config
SSH_CONFIGS_DIR="$HOME/.ssh/config.d"
sops_decrypt 'ssh_config.enc' "$SSH_CONFIGS_DIR/hosts"
ssh_config_include "$SSH_CONFIGS_DIR/hosts"
