local M = {}

--- Creates and returns LSP capabilities with nvim-cmp completion support.
M.make_capabilities = function()
  return require('blink.cmp').get_lsp_capabilities({}, true)
end

-- Returns lspconfig object.
--
-- Uses 'vim.lsp.config' since nvim 0.11+ or falls back to require('lspconfig').
M.lspconfig = function()
  if vim.lsp and vim.lsp.config then
    -- nvim 0.11+
    return vim.lsp.config
  end

  return require('lspconfig')
end

--- Setups specified language servers.
---
--- Function is compatibility wrapper around vim.lsp.config introduced in v0.11+ and legacy 'lspconfig' module.
--- @param kv table<string, vim.lsp.Config>
M.config = function(kv)
  -- nvim 0.11+
  if vim.lsp and vim.lsp.config then
    for name, cfg in pairs(kv) do
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
    return
  end

  local lspconfig = require('lspconfig')
  for name, cfg in pairs(kv) do
    lspconfig[name].setup(cfg)
  end
end

return M
