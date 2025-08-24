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
      preset = 'modern',
    },
    config = function(_, opts)
      require('which-key').setup(opts)
      require('keymap')
    end,
  },
}
