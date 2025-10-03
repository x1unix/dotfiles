return {
  {
    -- TreeWalker - AST traversal and manipulation.
    'aaronik/treewalker.nvim',

    ---@module 'treewalker'
    ---@type treewalker.Opts
    opts = {
      highlight_duration = 150,
    },
    keys = {
      -- Movement
      {
        '<C-k>',
        '<cmd>Treewalker Up<cr>',
        silent = true,
        desc = 'treewalker: go up',
        mode = { 'n', 'v' },
      },
      {
        '<C-j>',
        '<cmd>Treewalker Down<cr>',
        silent = true,
        desc = 'treewalker: go down',
        mode = { 'n', 'v' },
      },
      {
        '<C-h>',
        '<cmd>Treewalker Left<cr>',
        silent = true,
        desc = 'treewalker: go left',
        mode = { 'n', 'v' },
      },
      {
        '<C-l>',
        '<cmd>Treewalker Right<cr>',
        silent = true,
        desc = 'treewalker: go right',
        mode = { 'n', 'v' },
      },

      -- Swap
      {
        '<C-M-k>',
        '<cmd>Treewalker SwapUp<cr>',
        silent = true,
        desc = 'treewalker: swap up',
      },
      {
        '<C-M-j>',
        '<cmd>Treewalker SwapDown<cr>',
        silent = true,
        desc = 'treewalker: swap down',
      },
      {
        '<C-M-h>',
        '<cmd>Treewalker SwapLeft<cr>',
        silent = true,
        desc = 'treewalker: swap left',
      },
      {
        '<C-M-l>',
        '<cmd>Treewalker SwapRight<cr>',
        silent = true,
        desc = 'treewalker: swap right',
      },
    },
  },
}
