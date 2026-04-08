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
    '<Leader>[',
    ':tabp<cr>',
    mode = 'n',
    desc = 'tab: prev',
  },
  {
    '<Leader>]',
    ':tabn<cr>',
    mode = 'n',
    desc = 'tab: next',
  },
  -- Splits
  {
    '<Leader><Leader>',
    '<C-w>',
    mode = 'n',
    desc = 'splits: C^w',
    icon = icons.grid,
  },
  {
    '<Leader>h',
    '<C-w>h',
    mode = 'n',
    desc = 'splits: go left',
    icon = icons.grid,
  },
  {
    '<Leader>j',
    '<C-w>j',
    mode = 'n',
    desc = 'splits: go left',
    icon = icons.grid,
  },
  {
    '<Leader>k',
    '<C-w>k',
    mode = 'n',
    desc = 'splits: go down',
    icon = icons.grid,
  },
  {
    '<Leader>l',
    '<C-w>l',
    mode = 'n',
    desc = 'splits: go right',
    icon = icons.grid,
  },
  {
    '<Leader>q',
    ':close<cr>',
    mode = 'n',
    desc = 'split: close',
  },
  {
    '<Leader>Q',
    ':bprev | :bd#<cr>',
    mode = 'n',
    desc = 'buffer: close',
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
  -- Git keys
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
    '<Leader>n',
    '<Cmd>Neogit kind=tab<CR>',
    mode = 'n',
    desc = 'neogit',
    icon = {
      name = 'git',
      cat = 'filetype',
    },
  },
  -- NOTE: worktree hotkeys are defined at worktrees.lua for lazy-loading purposes.
  {
    '<Leader>G',
    group = 'worktrees',
    icon = {
      name = 'git',
      cat = 'filetype',
    },
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
    '<Leader>o',
    function()
      Snacks.picker.workspaces()
    end,
    mode = 'n',
    desc = 'workspace: open',
    icon = icons.folder,
  },
  {
    '<Leader>H',
    function()
      require('telescope.builtin').jumplist({
        layout_strategy = 'flex',
      })
    end,
    mode = 'n',
    desc = 'jumplist',
    icon = icons.jump,
  },
})
