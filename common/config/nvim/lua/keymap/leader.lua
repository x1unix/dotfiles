local wk = require('which-key')
local icons = require('util.icons')

-- Leader
wk.add({
  { '<Leader>', group = 'leader' },
  -- Tabs --
  {
    '<Leader>j',
    ':tabp<cr>',
    mode = 'n',
    desc = 'tab: prev',
  },
  {
    '<Leader>k',
    ':tabn<cr>',
    mode = 'n',
    desc = 'tab: next',
  },
  {
    '<Leader>q',
    ':bprev | :bd#<cr>',
    mode = 'n',
    desc = 'buffer: close',
  },
  {
    '<Leader>Q',
    ':close<cr>',
    mode = 'n',
    desc = 'split: close',
  },
  {
    '<Leader>g',
    function()
      ---@module 'snacks'
      ---@type snacks.plugins
      Snacks.lazygit()
    end,
    mode = 'n',
    desc = 'lazygit',
    icon = {
      name = 'git',
      cat = 'filetype',
    },
  },
  {
    '<Leader>p',
    function()
      local win_id = require('window-picker').pick_window()
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_set_current_win(win_id)
      end
    end,
    mode = 'n',
    desc = 'splits: leap',
    icon = icons.grid,
  },
  {
    '<Leader><Leader>',
    '<C-w>',
    mode = 'n',
    desc = 'splits: C^w',
    icon = icons.grid,
  },
})
