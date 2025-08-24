return {
  {
    'L3MON4D3/LuaSnip',
    version = '^2.4.0',
    build = 'make install_jsregexp',
    event = 'InsertEnter *',
    dependencies = {
      'stevearc/vim-vscode-snippets',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('luasnip').setup()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
