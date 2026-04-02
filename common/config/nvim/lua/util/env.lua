local M = {}

-- Appends given paths to PATH environment variable
M.append_paths = function(...)
  local paths = {}
  for _, v in ipairs({ ... }) do
    paths[#paths + 1] = vim.fn.expand(v)
  end
  paths[#paths + 1] = vim.env.PATH

  local v = table.concat(paths, ':')
  vim.env.PATH = v
end

return M
