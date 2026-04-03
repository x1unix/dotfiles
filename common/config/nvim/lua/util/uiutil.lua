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
          D._on_dir_picked(value)
        end)
      end
    end,
  })
end

-- File to be opened when directory is selected
local default_file = 'README.md'
local session_file = '.session.vim'

--- @param path string
D._on_dir_picked = function(path)
  vim.api.nvim_set_current_dir(path)

  -- Load session if exists in a dir.
  local sesspath = vim.fs.joinpath(path, session_file)
  if vim.fn.filereadable(sesspath) then
    local sessions = require('mini.sessions')
    sessions.read(session_file, { force = true })
    return
  end

  -- Open the readme if exists.
  if vim.fn.filereadable(default_file) then
    -- Replicate what ministarter does
    local bufid = vim.fn.bufadd(vim.fn.fnameescape(default_file))
    pcall(vim.api.nvim_win_set_buf, 0, bufid)
    return
  end

  -- Otherwise, show file explorer
  vim.cmd('e .')
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
M.session_file = session_file

return M
