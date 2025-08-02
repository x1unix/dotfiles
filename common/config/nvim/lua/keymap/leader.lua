local wk = require('which-key')

-- Leader
wk.add({
  { '<Leader>', group = 'leader' },
  {
    '<Leader>\\',
    ':Neotree toggle<cr>',
    mode = 'n',
    desc = 'neotree',
  },
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
    ':bnext | :bd#<cr>',
    mode = 'n',
    desc = 'buffer: close',
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
  },
  {
    '<Leader><Leader>',
    '<C-w>',
    mode = 'n',
    desc = '<C-w>',
  },
})
