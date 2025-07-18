local M = {}

--- Creates and returns LSP capabilities with nvim-cmp completion support.
M.make_capabilities = function()
  return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

return M
