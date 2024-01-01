export EDITOR=nvim

shell_path "$HOME/.local/bin"
shell_source "$HOME/.cargo/env"
[ -n "$HOMEBREW_PREFIX" ] && . "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
