local M = {
  __ok__ = false,
  __ostype__ = 0,
}

local OSTYPE_LINUX = 1
local OSTYPE_DARWIN = 2
local OSTYPE_WIN32 = 3

M.__init__ = function()
  if M.__ok__ then
    return
  end

  local uname = vim.uv.os_uname()
  local sysname = uname.sysname

  if sysname == 'Darwin' then
    M.__ostype__ = OSTYPE_DARWIN
  elseif sysname == 'Linux' then
    M.__ostype__ = OSTYPE_LINUX
  elseif sysname:match('Windows') then
    M.__ostype__ = OSTYPE_WIN32
  end

  M.__ok__ = true
end

M.is_android = function()
  return vim.env.ANDROID_DATA ~= nil
end

M.is_darwin = function()
  M.__init__()
  return M.__ostype__ == OSTYPE_DARWIN
end

M.is_linux = function()
  M.__init__()
  return M.__ostype__ == OSTYPE_LINUX
end

M.is_win32 = function()
  M.__init__()
  return M.__ostype__ == OSTYPE_WIN32
end

return M
