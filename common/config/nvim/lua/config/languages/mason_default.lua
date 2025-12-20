-- List of Mason packages for a general x86-64 systems.
-- See: plugins/languges/mason.lua.

return {
  -- List of language servers to install and configure.
  -- Passed to mason-lspconfig.nvim.
  lsp_servers = {
    'lua_ls',
    --- Already provided by plugins:
    -- 'rust_analyzer',
    -- 'gopls',
    'terraformls',
    'buf_ls',
    'bashls',
    'clangd',
    'eslint',

    'html',
    'emmet_language_server',
    'cssls',
    'tailwindcss',

    -- Misc
    'yamlls',
    'jsonls',
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
    'codelldb',
    'shfmt',
  },
}
