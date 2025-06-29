# NeoVim Config

## Introduction

This config is made from scratch and not based on any template like nvchad or other.

Packages are managed by *lazy.nvim*.

## Structure

* `init.lua` - Main entrypoint.
* `lua`
  * `autocmd` - Custom autocmd hooks.
  * `config`
    * `init.lua` - Vim configuration.
    * `theme.lua` - Theming config.
  * `keymap` - Keymaps managed by [which-key](https://github.com/folke/which-key.nvim).
  * `plugins`
    * `core` - Core plugins
    * `languages` - Language support (LSP, debug and other integrations).
    * `ui` - User interface enhancements.
    * `ux` - User experience enhancements.
    * `x-other` - Low-priority plugins.
