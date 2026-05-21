local M = {}

local uv = vim.uv or vim.loop

-- Appends given paths to PATH environment variable
--
-- Note: nil values are ignored
M.append_paths = function(...)
  local paths = {}
  for _, v in ipairs({ ... }) do
    if v ~= nil then
      local path = vim.fn.expand(v)
      if uv.fs_stat(path) ~= nil then
        paths[#paths + 1] = path
      end
    end
  end
  paths[#paths + 1] = vim.env.PATH

  local v = table.concat(paths, ':')
  vim.env.PATH = v
end

return M
