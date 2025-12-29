-- Configuration for null-ls.nvim.
-- Extra tools (linters, formatters, etc) powered by null-ls.nvim

local M = {}

---@module 'null-ls'
---@param null_ls table
M.get_sources = function(null_ls)
  return {
    -- Nix formatter
    null_ls.builtins.formatting.nixfmt,
  }
end

return M
