# Das Dotfiles

My personal dotfiles and bootstrap configs for different systems.

Bootstrapping is managed [deploy.sh](./deploy.sh) script.

## Install

* Find your deployment target using `./deploy.sh list`
* Run `./deploy.sh apply <your target> --all`

> [!NOTE]
> Use `./deploy.sh info` to get information about each target.

## Post-installation

Install [oh-my-zsh](https://ohmyz.sh/) and add following into `.zshrc`:

```shell
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git nvm docker-compose vi-mode fzf)

[ -f ~/.config/shell/loader.sh ] && . ~/.config/shell/loader.sh
```
