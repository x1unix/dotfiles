return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
      'folke/trouble.nvim',
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts or {}, {
        lazygit = {},
        input = {},
        image = {},
        styles = {
          input = {
            border = 'rounded',
          },
        },
        picker = {
          actions = require('trouble.sources.snacks').actions,
          win = {
            input = {
              keys = {
                ['<c-t>'] = {
                  'trouble_open',
                  mode = { 'n', 'i' },
                },
              },
            },
          },
        },
      })
    end,
  },
}
