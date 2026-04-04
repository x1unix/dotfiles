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
  local header_func = get_header_func()
  if not header_func then
    return 'Neovim'
  end
  local header = join_strings(header_func())
  return header .. '\n\n' .. vim.fn.getcwd()
end

-- File to be opened when directory is selected
local default_file = 'README.md'

M.open_readme = function()
  if not vim.fn.filereadable(default_file) then
    return false
  end

  -- Replicate what ministarter does
  local bufid = vim.fn.bufadd(vim.fn.fnameescape(default_file))
  pcall(vim.api.nvim_win_set_buf, 0, bufid)
  return true
end

--- @class OpenDirOpts
--- @field reset_session boolean | nil

--- Switches neovim editor to a different working directory and restores session.
--- If target dir doesn't contain any session - opens README.md.
---
--- Function aims to replicate a classic "Open Folder" action found in most classic editors/IDEs.
---
--- @param path string
--- @param opts OpenDirOpts | nil
M.open_directory = function(path, opts)
  local sessutil = require('util.sessionutil')

  if not sessutil.assert_has_unsaved_buffers('Cannot change directory') then
    return
  end

  -- Try to load a session from directory.
  if sessutil.open_dir_session(path) then
    return
  end

  -- Manually change work dir and try to open README.md or file explorer.
  vim.api.nvim_set_current_dir(path)
  if not M.open_readme() then
    vim.cmd('e .')
  end
end

local D = {
  _is_open = false,
  _is_init = false,

  --- @type string|nil
  _value = nil,

  --- @module "mini.files"
  _files = nil,
}

D.is_active = function()
  return D._is_open
end

D._init = function()
  if D._is_init then
    return
  end

  -- Setup on-close hooks to sync picker state.
  D._is_init = true
  D._files = require('mini.files')
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesExplorerClose',
    callback = function()
      if not D._is_open or not D._value then
        return
      end

      D._is_open = false
      local value = D._value
      D._value = nil

      if value then
        vim.schedule(function()
          M.open_directory(value)
        end)
      end
    end,
  })
end

D.open = function()
  -- NOTE: directory selection action is handled in autocmd declared in ../keymap/mini.lua
  D._is_open = true
  D._init()

  D._files.open(nil, true, {
    content = {
      filter = function(a)
        return a.fs_type == 'directory'
      end,
    },
  })
end

--- @param path string|nil
--- @param should_close boolean|nil
D.set_value = function(path, should_close)
  D._value = path
  if should_close then
    D._files.close()
  end
end

M.open_dir_dialog = D

return M
