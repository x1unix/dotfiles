return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      -- The plugin is packaged as a native neovim PM plugin,
      -- placing bootstrap code into '/plugin' instead of classic '/lua/lspconfig/init.lua'.
      --
      -- lazy.vim doesn't call '/plugin' dir runtime files.
      -- Call it manually to init the plugin.
      vim.cmd('runtime plugin/lspconfig.lua')
      require('config.lsp').setup()
    end,
  },
}
