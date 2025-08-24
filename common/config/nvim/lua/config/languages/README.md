# Languages Configuration

This directory contains packages to use for language support.

## `grammars.lua`

This file contains list of Treesitter grammars to install by nvim-treesitter.

## `mason_*.lua`

Platform-specific list of LSP servers and tools to install by Mason.

List is split as some packages aren't available on non AMD64-platforms.

>[!NOTE]
> By default, `mason_default.lua` is used if no matching platform-specific file was found.
> See [util/configutil.lua](../../util/configutil.lua) for details.

