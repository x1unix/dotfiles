local lspconfig = require('lspconfig')

-- Run ':checkhealth lsp' to see the status or to troubleshoot.
-- Read ':help lspconfig' for details. Read ':help lspconfig-all' for the full list of server-specific details.
--
-- For servers not on your $PATH (e.g., jdtls, elixirls), you must manually set the cmd parameter when calling setup().
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}
