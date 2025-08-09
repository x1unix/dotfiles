-- Language servers and tools to install.
-- See: plugins/languges/mason.lua.

return {
  -- List of treesitter languages to install.
  -- Passed to nvim-treesitter.
  languages = {
    'go',
    'gomod',
    'gosum',
    'proto',
    'jsonc',
    'ini',
    'lua',
    'make',
    'nix',
    'php',
    'terraform',
    'typescript',
    'xml',
    'yaml',
  },

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
  },

  -- Certain Mason packages aren't compatible with Android.
  -- Here is a separate install list for Android only.
  android = {
    lsp_servers = {
      'terraformls',
      'buf_ls',
      'bashls',
      'eslint',
    },

    tools = {
      'prettier',
    },
  },
}
