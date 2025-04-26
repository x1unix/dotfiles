#!/usr/bin/env sh
set -e

script_path="$(readlink -f -- "$0")"
dir="$(dirname -- "$script_path")"

step_brew() {
  echo ":: Installing brew packages..."
  brew bundle --file="$dir/Brewfile"
}

step_dots() {
  echo ":: Linking dotfiles..."
  stow -t "$HOME" .
}

step_vim() {
  echo ":: Installing vim-plug..."
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  echo ":: Installing plugins..."
  nvim -es -u '.config/nvim/init.vim' -i NONE -c "PlugInstall" -c "qa"
}

step_shmgr() {
  echo ":: Installing shmgr..."
  echo '[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh' >> ~/.zshrc
  "$dir/.local/bin/shmgr" gen
}

step_tmux() {
  echo ":: Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  $HOME/.tmux/plugins/tpm/bin/install_plugins
}

step_all() {
  step_brew
  step_dots
  step_vim
  step_shmgr
  step_tmux
}

case "$1" in
  'brew')
    step_brew
    ;;
  'vim')
    step_vim
    ;;
  'dots')
    step_dots
    ;;
  'shmgr')
    step_shmgr
    ;;
  'tmux')
    step_tmux
    ;;
  'all' | '')
    step_all
    ;;
  'help' | '-h')
    echo "Usage: $0 [all|brew|dots|vim|shmgr] [-h]"
    exit
    ;;
  *)
    echo "Invalid step option '$1'. Valid options: all, brew, dots, vim, shmgr"
    exit 1
    ;;
esac
