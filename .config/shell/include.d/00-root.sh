export EDITOR=nvim

shell_path "$HOME/.local/bin"
shell_path "/usr/local/bin"
#export PATH="$PATH:/usr/local/bin:$HOME/.local/bin"

if [ -f "$HOME/.cargo/env" ]; then
  shell_source "$HOME/.cargo/env"
fi

[ -n "$HOMEBREW_PREFIX" ] && . "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
