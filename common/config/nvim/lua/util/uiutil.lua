local M = {}

local function join_strings(string_list)
  local ret = ''
  for i, v in ipairs(string_list) do
    ret = ret .. '\n' .. v
  end
  return ret
end

M.get_header = function()
  local theme = require('config.theme')
  if not theme.starter or not theme.starter.header then
    return nil
  end

  local header = theme.starter.header()
  return join_strings(header) .. '\n\n' .. vim.fn.getcwd()
end

return M
