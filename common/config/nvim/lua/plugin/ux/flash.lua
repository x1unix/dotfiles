return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    -- enabled = false,
    ---@type Flash.Config
    opts = {
      modes = {
        -- Disable search with 'f' key (it's really annoying).
        char = { enabled = false },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'flash: treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'flash: remote',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'flash: treesitter search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'flash: toggle search',
      },
    },
  },
}
