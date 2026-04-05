local utils = require('pkg.mini-session-workspaces.utils')

--- @class MiniWorkspaces.PluginConfig
--- @field history_file string
--- @field history_max_items number

local M = {
  --- @module 'mini.sessions'
  _sessions = nil,

  --- @type MiniWorkspaces.PluginConfig
  config = {
    history_file = vim.fs.joinpath(vim.fn.stdpath('data'), ''),
    history_max_items = 5,
  },
}

--- @class MiniWorkspaces.Options
--- @field history_file string|nil Path to a file to store workspaces history.
--- @field history_max_items number|nil Max number of workspaces to store in a history file.

--- @param opts MiniWorkspaces.Options|nil
M.setup = function(opts)
  local ok, sessions = pcall(require, 'mini.sessions')
  if not ok then
    error('"mini.sessions" plugin is not installed.')
    return
  end

  if #sessions.config.file == 0 then
    error('invalid "mini.sessions" config: "file" should not be empty.')
    return
  end

  M._sessions = sessions
  M.config = vim.tbl_deep_extend('force', vim.deepcopy(M.config), opts or {})
end

M.session_file = function()
  return M._sessions.config.file
end

--- Returns whether there is any session loaded (local or global).
M.is_session_loaded = function()
  return vim.v.this_session ~= ''
end

--- Returns whether a directory (local) session is loaded.
M.is_workspace_open = function()
  return vim.v.this_session == M.session_file()
end

--- @class MiniWorkspaces.OpenWorkspaceOpts
--- @field create_if_missing boolean|nil Create a new local session if missing.
--- @field skip_session_save boolean|nil Don't save current session.
--- @field on_created function|nil Hook to run if a new session was

--- Opens a local session in a given directory.
--- Aborts if local session doesn't exist, unless [opts.create_if_missing] is set to true.
---
--- Returns success result.
---
--- @param path string
--- @param opts MiniWorkspaces.OpenWorkspaceOpts | nil
M.open_workspace = function(path, opts)
  local next_session_exists = M.dir_has_session(path)
  local create_if_missing = opts and opts.create_if_missing
  if not next_session_exists and not create_if_missing then
    return false
  end

  -- mini throws an error when switching between local sessions.
  -- unload current local session first.
  if M.is_session_loaded() then
    M._sessions.write(nil, {
      verbose = false,
      force = true,
    })
    M._sessions.detected[vim.v.this_session] = nil
    vim.v.this_session = ''
    return false
  end

  -- disable mini temporary to avoid session corruption.
  vim.g.minisessions_disable = true

  -- servers should be closed only after all docs are closed to prevent autorestart.
  if #vim.api.nvim_list_bufs() > 0 then
    utils.dispose_workspace()
  end

  -- unload current session.
  vim.api.nvim_set_current_dir(path)
  local next_session_path = vim.fs.joinpath(path, M.session_file())

  if next_session_exists then
    vim.cmd(('silent! source %s'):format(vim.fn.fnameescape(next_session_path)))

    -- Enable mini back
    vim.schedule(function()
      vim.v.this_session = M.session_file()
      M._sessions.detected[vim.v.this_session] = utils.new_session()
      vim.g.minisessions_disable = false
    end)
    return true
  end

  if opts and opts.on_created then
    opts.on_created(path)
  end

  vim.schedule(function()
    vim.v.this_session = M.session_file()
    M._sessions.detected[vim.v.this_session] = utils.new_session()
    vim.g.minisessions_disable = false
    M._sessions.write(vim.v.this_session, { force = true, verbose = true })
  end)
  return true
end

--- @class MiniWorkspaces.SaveWorkspaceOpts
--- @field force boolean|nil Create a new session if not exists.
--- @field wipeout boolean|nil Close all buffers after save.

--- Save directory session.
--- @param path string | nil
--- @param opts MiniWorkspaces.SaveWorkspaceOpts|nil
M.save_workspace = function(path, opts)
  local force = opts and opts.force
  local wipeout = opts and opts.wipeout

  path = path or vim.fn.getcwd()
  local exists = M.dir_has_session(path)
  if force or exists then
    M._sessions.write(M.session_file(), {
      force = true,
      verbose = false,
    })

    if wipeout then
      utils.dispose_workspace()
    end
  end
end

--- @class MiniWorkspaces.DeleteWorkspaceOpts
--- @field force boolean whether to allow deletion of a current session.

--- Delete local session in a directory.
---
--- @param path string|nil
--- @param opts MiniWorkspaces.DeleteWorkspaceOpts|nil
M.delete_workspace = function(path, opts)
  local cwd = vim.fn.getcwd()
  path = path or cwd

  if path ~= cwd then
    -- Non-active local sessions have to be removed manually.
    local session_file = vim.fs.joinpath(path, M.session_file())
    local exists = vim.fn.filereadable(session_file)
    if exists then
      vim.fn.delete(session_file)
    end

    return exists
  end

  local session = vim.v.this_session
  if session == '' then
    return false
  end

  M._sessions.delete(session, { force = opts and opts.force })
  vim.v.this_session = ''
  return true
end

--- Returns whether a given directory has a session.
--- @param path string
M.dir_has_session = function(path)
  local sesspath = vim.fs.joinpath(path, M.session_file())
  return vim.fn.filereadable(sesspath)
end

return M
