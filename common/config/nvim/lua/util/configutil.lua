local os = require('util.os')

---@type string
local config_ns = 'config.languages.mason_'

local M = {
  __cache__ = nil,
}

--- Returns platform-specific Mason config filename.
--- @return string
local function get_mason_config_name()
  if os.is_win32() then
    return 'windows'
  end

  if os.is_android() then
    return 'android'
  end

  if os.is_arm() and os.is_linux() then
    return 'linux_aarch64'
  end

  return 'default'
end

---@class MasonPackagesSpec
---@field lsp_servers table[string]
---@field tools table[string]

--- Loads and returns platform-specific Mason config.
--- @return MasonPackagesSpec
M.get_mason_config = function()
  if M.__cache__ then
    return M.__cache__
  end

  local cfg_suffix = get_mason_config_name()
  local ok, module = pcall(require, config_ns .. cfg_suffix)
  if not ok then
    module = require(config_ns .. 'default')
  end

  M.__cache__ = module
  return module
end

return M
