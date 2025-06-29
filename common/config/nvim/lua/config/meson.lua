-- Language servers and tools to install.
-- See: plugins/languges/mason.lua.

return {
  -- List of language servers to install and configure.
  -- Passed to mason-lspconfig.nvim.
  lsp_configs = {
    'lua_ls',
    'rust_analyzer',
    'gopls',
    'terraformls',
    'buf_ls',
    'bashls',
    'clangd',
    'eslint',
  },

  -- List of other tools to install by Mason.
  -- Passed to mason-tool-installer.nvim.
  --
  -- Put here tools not recognized by mason-lspconfig.nvim.
  --
  -- See: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim?tab=readme-ov-file#configuration
  tools = {
    'stylua',
    'prettier',
  },
}
