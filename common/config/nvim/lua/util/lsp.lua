local M = {}

--- Creates and returns LSP capabilities with nvim-cmp completion support.
M.make_capabilities = function()
  return require('blink.cmp').get_lsp_capabilities({}, true)
end

return M
