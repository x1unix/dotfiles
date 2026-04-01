return {
  {
    'pmizio/typescript-tools.nvim',
    event = 'BufReadPre',
    ft = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      {
        'saghen/blink.cmp',
        -- Ensure blink.cmp is loaded before typescript-tools
        lazy = false,
        priority = 1000,
      },
    },
    config = function()
      local tsconfig = require('config.languages.typescript')
      require('typescript-tools').setup({
        capabilities = require('util.lsp').make_capabilities(),
        settings = tsconfig.settings,
        handlers = tsconfig.handlers,
        on_attach = tsconfig.on_attach,
      })
    end,
  },
  {
    'razak17/tailwind-fold.nvim',
    opts = {
      min_chars = 50,
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'html', 'svelte', 'astro', 'vue', 'typescriptreact' },
  },

  {
    'MaximilianLloyd/tw-values.nvim',
    keys = {
      { '<Leader>cv', '<CMD>TWValues<CR>', desc = 'Tailwind CSS values' },
    },
    opts = {
      border = 'rounded', -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
    },
  },

  {
    'axelvc/template-string.nvim',
    event = 'InsertEnter',
    ft = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
    },
    config = true, -- run require("template-string").setup()
  },

  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC' },
    config = true,
  },

  {
    'dmmulroy/ts-error-translator.nvim',
    config = true,
  },
}
