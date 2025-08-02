local M = {}

local function join_strings(string_list)
  local ret = ''
  for i, v in ipairs(string_list) do
    ret = ret .. '\n' .. v
  end
  return ret
end

local function get_header_func()
  local theme = require('config.theme')
  local os = require('util.os')

  if os.is_android() and theme.android and theme.android.starter then
    return theme.android.starter.header
  end

  if theme.starter then
    return theme.starter.header
  end

  return nil
end

M.get_header = function()
  local theme = require('config.theme')
  if not theme.starter or not theme.starter.header then
    return nil
  end

  local header_func = get_header_func()
  if not header_func then
    return 'Neovim'
  end
  local header = join_strings(theme.starter.header())
  return header .. '\n\n' .. vim.fn.getcwd()
end

return M
