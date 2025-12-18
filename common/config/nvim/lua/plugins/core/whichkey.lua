local helix_left = {
  win = {
    width = { min = 30, max = 60 },
    height = { min = 4, max = 0.75 },
    padding = { 0, 1 },
    col = 0,
    row = -1,
    border = 'rounded',
    title = true,
    title_pos = 'left',
  },
  layout = {
    width = { min = 30 },
  },
}

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    ---@module 'which-key'
    ---@type wk.Opts
    opts = {
      -- preset = 'modern',
      win = helix_left.win,
      layout = helix_left.layout,
    },
    config = function(_, opts)
      require('which-key').setup(opts)
      require('keymap')
    end,
  },
}
