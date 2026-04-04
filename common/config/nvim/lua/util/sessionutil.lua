local M = {}

local function var_dump(v)
  print(vim.inspect(v))
end

local function prompt_input(prompt, cb)
  if vim.ui and vim.ui.input then
    vim.ui.input({
      prompt = prompt,
    }, cb)
    return
  end

  local r = vim.fn.input(prompt)
  cb(r)
end

-- Prompt a session name and call callback function with result.
--
-- Uses current session name if [vim.v.this_session] is not empty.
-- Uses [vim.fn.getwd] if user prompt is empty.
--
-- @param cb function Callback to pass session name.
M.prompt_session_name = function(cb)
  local current_name = vim.v.this_session
  if current_name and current_name ~= '' then
    -- Don't return session name and let mini.session infer current session name.
    -- Even if session name matches - session FD is locked by mini.files and file isn't writable.
    cb(nil)
    return
  end

  prompt_input('Enter a new session name (optional): ', function(result)
    if result and result ~= '' then
      cb(result)
      return
    end

    -- Try guess from a current workdir if empty
    result = vim.fn.getcwd():gsub('[\\/]', '__')
    cb(result)
  end)
end

--- Per-directory local session file.
M.session_file = '.session.vim'

-- Code copied from mini.nvim/lua/mini/sessions.lua
M.get_this_session = function()
  return vim.fs.normalize(vim.v.this_session)
end

local function new_session(session_path, session_type)
  return {
    modify_time = vim.fn.getftime(session_path),
    name = vim.fn.fnamemodify(session_path, ':t'),
    path = session_path,
    type = session_type,
  }
end

local function get_unsaved_listed_buffers()
  return vim.tbl_filter(function(buf_id)
    return vim.bo[buf_id].modified and vim.bo[buf_id].buflisted
  end, vim.api.nvim_list_bufs())
end

M.assert_has_unsaved_buffers = function(msg)
  local unsaved_buffs = get_unsaved_listed_buffers()
  if #unsaved_buffs == 0 then
    return true
  end

  vim.notify(('%s, there are %d unsaved buffers.'):format(#unsaved_buffs, msg), vim.log.levels.ERROR)
  return false
end

--- Returns whether there is any session loaded (local or global).
M.is_session_loaded = function()
  return vim.v.this_session ~= ''
end

--- Returns whether a directory (local) session is loaded.
M.is_local_session_loaded = function()
  return vim.v.this_session == M.session_file
end

--- @class OpenDirSessionOpts
--- @field create_if_missing boolean|nil
--- @field on_created function|nil

M.open_dir_session = function(path, opts)
  local next_session_exists = M.dir_has_session(path)
  local create_if_missing = opts and opts.create_if_missing
  if not next_session_exists and not create_if_missing then
    return false
  end

  -- mini throws an error when switching between local sessions.
  -- unload current local session first.
  local sessions = require('mini.sessions')
  if M.is_session_loaded() then
    sessions.write(nil, {
      verbose = false,
      force = true,
    })
    sessions.detected[vim.v.this_session] = nil
    vim.v.this_session = ''
  end

  -- disable mini temporary to avoid session corruption.
  vim.g.minisessions_disable = true

  -- servers should be closed only after all docs are closed to prevent autorestart.
  vim.cmd('silent! %bwipeout!')
  vim.lsp.stop_client(vim.lsp.get_clients())

  -- unload current session.
  vim.api.nvim_set_current_dir(path)
  local next_session_path = vim.fs.joinpath(path, M.session_file)

  if next_session_exists then
    vim.cmd(('silent! source %s'):format(vim.fn.fnameescape(next_session_path)))

    -- Enable mini back
    vim.schedule(function()
      vim.v.this_session = M.session_file
      sessions.detected[M.session_file] = new_session()
      vim.g.minisessions_disable = false
    end)
    return true
  end

  if opts and opts.on_created then
    opts.on_created(path)
  end

  vim.schedule(function()
    vim.v.this_session = M.session_file
    sessions.detected[M.session_file] = new_session()
    vim.g.minisessions_disable = true
    sessions.write(M.session_file, { force = true, verbose = true })
  end)
  return true
end

--- Open a local directory session.
--- Returns false if directory doesn't contain a local session.
---
--- @param path string
--- @param opts OpenDirSessionOpts | nil
M.open_dir_session2 = function(path, opts)
  local next_session_exists = M.dir_has_session(path)
  local create_if_missing = opts and opts.create_if_missing
  if not next_session_exists and not create_if_missing then
    return false
  end

  -- mini throws an error when switching between local sessions.
  -- unload current local session first.
  local sessions = require('mini.sessions')
  if M.is_local_session_loaded() then
    print('is_local_session_loaded')
    sessions.write(M.session_file, {
      verbose = false,
    })
    vim.v.this_session = ''
  end

  if next_session_exists then
    -- switch from global to a local session.
    -- mini refuses to load items that not present in the detected list.
    -- manually inject session and load it.
    sessions.detected[M.session_file] = new_session(vim.fs.joinpath(path, M.session_file), 'local')
    print('next_session_exists')
    sessions.read(M.session_file, { force = true, verbose = false })
    return true
  end

  -- No session, create one from scratch. Save existing session if necessary.
  if M.is_session_loaded() then
    print('is_session_loaded')
    sessions.write(nil, { force = true, verbose = false })
    vim.v.this_session = ''
  end

  print('bwipeout')
  vim.cmd('silent! %bwipeout!')
  vim.api.nvim_set_current_dir(path)
  if opts and opts.on_created then
    opts.on_created(path)
  end

  sessions.write(M.session_file, { force = true, verbose = true })
  return true
end

--- @param path string
--- @param force boolean | nil
M.save_dir_session = function(path, force)
  local exists = M.dir_has_session(path)
  if force or exists then
    require('mini.sessions').write(M.session_file, {
      force = true,
      verbose = false,
    })
  end
end

--- @param path string
M.dir_has_session = function(path)
  local sesspath = vim.fs.joinpath(path, M.session_file)
  local ok = vim.fn.filereadable(sesspath)
  return vim.fn.filereadable(sesspath)
end

return M
