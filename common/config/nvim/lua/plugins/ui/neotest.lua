return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',

      -- Adapters
      'nvim-neotest/neotest-plenary',
      'fredrikaverpil/neotest-golang',
      'marilari88/neotest-vitest',
      'mrcjkb/rustaceanvim',
    },
    opts = function(_, opts)
      if opts.adapters == nil then
        opts.adapters = {}
      end

      vim.list_extend(opts.adapters, {
        require('neotest-golang'),
        require('neotest-vitest'),
        require('rustaceanvim.neotest'),
      })
    end,
  },
  {
    'andythigpen/nvim-coverage',
    version = '*',
    config = function()
      require('coverage').setup()
    end,
  },
}
