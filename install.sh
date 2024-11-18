#!/usr/bin/env sh
set -e

script_path="$(readlink -f -- "$0")"
dir="$(dirname -- "$script_path")"

config="$HOME/.config"

link_path() {
  ln -s -v "$dir/$1" "$HOME/$1"
}

link_home() {
  ln -s -v "$dir/$1" "$HOME/$1"
}

link_config() {
  link_path ".config/$1"
}

link_local() {
  link_path ".local/$1"
}

echo ":: Linking dotfiles..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

link_config "shell"
link_config "nvim"

link_local "bin/shmgr"
link_local "bin/unlock"

link_home ".npmrc"
link_home ".gitconfig"
link_home ".tmux.conf"

echo ":: Installing vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo ":: Installing shmgr..."

echo '[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh' >> ~/.zshrc
"$dir/.local/bin/shmgr" gen
#link_home ".zshenv"

echo ":: Installing brew packages..."
brew bundle --file="$dir/Brewfile"
