local osutil = require('util.os')

-- Macs are usually laptops and having a bigger font is appreciated.
local font_size = osutil.is_darwin() and '14' or '11'

vim.g.neovide_font_hinting = 'none'
vim.g.neovide_font_edging = 'subpixelantialias'
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_scroll_animation_length = 0.1
vim.o.guifont = 'IosevkaTerm Nerd Font:h' .. font_size .. ':w-0.5:#e-subpixelantialias:#h-none'

-- HACK: when nvim started via desktop entry or inside Neovide, PATH isn't initialized.
require('util.env').append_paths(
  '~/.nix-profile/bin',
  '/nix/var/nix/profiles/default/bin',
  '/run/current-system/sw/bin',
  '~/.local/bin',
  '~/go/bin'
)

-- vim.g.experimental_layer_grouping = true
-- vim.g.neovide_experimental_layer_grouping = true

-- MacOS stuff
vim.g.neovide_corner_preference = 'do_not_round'
vim.g.neovide_show_border = false

-- Blur
-- vim.opt.winblend = 100
-- vim.opt.pumblend = 100
-- vim.g.neovide_floating_blur_amount_x = 30
-- vim.g.neovide_floating_blur_amount_y = 30
