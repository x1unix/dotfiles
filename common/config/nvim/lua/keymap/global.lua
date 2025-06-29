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
  -- Session manager --
  {
    '<Leader>M',
    '<cmd>SessionManager<cr>',
    mode = 'n',
    desc = 'session manager',
  },
})
