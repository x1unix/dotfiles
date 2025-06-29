return {
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'lua_ls', 'rust_analyzer', 'gopls', 'terraformls', 'buf_ls',
        'bashls', 'clangd', 'eslint',
      }
    },
    dependencies = {
     {
        'mason-org/mason.nvim',
        opts = {},
      },
      'neovim/nvim-lspconfig',
    },
  },
}
