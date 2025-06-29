local meson = require('config.meson')

return {
  {
    -- Automatic nvim-lspconfig config by Meson.
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = meson.lsp_configs,
    },
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {},
      },
      'neovim/nvim-lspconfig',
    },
  },
  {
    -- Integration with null-ls.
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'nvimtools/none-ls.nvim',
    },
    config = function()
      -- TODO: add null-ls config
    end,
  },
  {
    -- Automatic tools installation using Meson.
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = meson.tools,
    },
    dependencies = {
      'mason-org/mason.nvim',
      'jay-babu/mason-null-ls.nvim',
      -- Integration with nvim-dap.
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = {
          'mfussenegger/nvim-dap',
          'williamboman/mason.nvim',
        },
      },
    },
  },
}
