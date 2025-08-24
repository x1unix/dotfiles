-- List of Mason packages for Android (Termux).
-- See: plugins/languges/mason.lua.

return {
  -- List of language servers to install and configure.
  -- Passed to mason-lspconfig.nvim.
  lsp_servers = {
    'terraformls',
    'buf_ls',
    'bashls',
    'eslint',
  },

  -- List of other tools to install by Mason.
  -- Passed to mason-tool-installer.nvim.
  --
  -- Put here tools not recognized by mason-lspconfig.nvim.
  --
  -- See: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim?tab=readme-ov-file#configuration
  tools = {
    'prettier',
  },
}
