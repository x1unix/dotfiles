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
    ':bprev | :bd#<cr>',
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
    '<Leader>p',
    function()
      local win_id = require('window-picker').pick_window()
      if win_id and vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_set_current_win(win_id)
      end
    end,
    mode = 'n',
    desc = 'splits: switch',
  },
  {
    '<Leader><Leader>',
    '<C-w>',
    mode = 'n',
    desc = 'Ctrl+w',
  },
})
