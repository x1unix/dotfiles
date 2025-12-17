local wk = require('which-key')
local icons = require('util.icons')

-- Leader
wk.add({
  { '<Leader>', group = 'leader' },
  {
    '<leader>e',
    function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      ---@module 'mini.files'
      ---@type mini.files.MiniFiles
      MiniFiles.open(path)
      MiniFiles.reveal_cwd()
    end,
    mode = 'n',
    desc = 'mini.files',
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
  -- Search --
  {
    '<Leader>\\',
    -- '<cmd>Telescope commands<cr>',
    function()
      Snacks.picker()
    end,
    mode = 'n',
    desc = 'commands',
  },
  {
    '<Leader>w',
    function()
      require('telescope').extensions['telescope-tabs'].list_tabs({
        layout_strategy = 'flex',
      })
    end,
    mode = 'n',
    desc = 'list tabs',
  },
  {
    '<Leader>;',
    function()
      Snacks.picker.files({ hidden = true })
      -- require('telescope.builtin').find_files({
      --   layout_strategy = 'flex',
      --   hidden = true,
      -- })
    end,
    mode = 'n',
    desc = 'find files',
  },
  {
    '<Leader>f',
    function()
      require('telescope.builtin').live_grep({
        layout_strategy = 'flex',
        hidden = true,
      })
    end,
    mode = 'n',
    desc = 'grep',
    icon = icons.action_search,
  },
  {
    '<Leader>/',
    function()
      require('telescope.builtin').current_buffer_fuzzy_find({
        layout_strategy = 'flex',
        hidden = true,
      })
    end,
    mode = 'n',
    desc = 'find in file',
    icon = icons.action_search,
  },
  {
    '<Leader>b',
    function()
      require('telescope.builtin').buffers({
        layout_strategy = 'flex',
      })
    end,
    mode = 'n',
    desc = 'buffers',
  },
  {
    '<Leader>B',
    function()
      require('telescope').extensions.scope.buffers({
        layout_strategy = 'flex',
      })
    end,
    mode = 'n',
    desc = 'buffers: all',
  },
})
