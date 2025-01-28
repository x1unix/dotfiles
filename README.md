# Das Dotfiles

## Install

* `./install.sh all`

## Post-installation

Install [oh-my-zsh](https://ohmyz.sh/) and add following into `.zshrc`:

```shell
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git nvm docker-compose vi-mode fzf)

[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh
```
