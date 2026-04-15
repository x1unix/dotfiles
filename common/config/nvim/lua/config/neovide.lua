vim.g.neovide_font_hinting = 'none'
vim.g.neovide_font_edging = 'subpixelantialias'
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_scroll_animation_length = 0.1
vim.o.guifont = 'IosevkaTerm Nerd Font:h11:w-0.5:#e-subpixelantialias:#h-none'

-- HACK: when nvim started via desktop entry or inside Neovide, PATH isn't initialized.
require('util.env').append_paths('~/.local/bin', '~/go/bin')

-- vim.g.experimental_layer_grouping = true
-- vim.g.neovide_experimental_layer_grouping = true
