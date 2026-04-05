--- Module provides helpers to connect session management to user interface.
local M = {}

--- @module 'snacks'
--- @param cb fun(result: string|nil)
--- @param opts snacks.input.Opts
local function prompt_input(opts, cb)
  if vim.ui and vim.ui.input then
    vim.ui.input(opts, cb)
    return
  end

  local r = vim.fn.input(opts.prompt)
  cb(r)
end

--- Prompt a session name and call callback function with result.
---
--- Uses current session name if [vim.v.this_session] is not empty.
--- If prompt is empty - saves a local session.
---
--- @param cb fun(name: string|nil, is_local: boolean|nil) Callback to pass session name.
local prompt_session_name = function(cb)
  local current_name = vim.v.this_session
  if current_name and current_name ~= '' then
    -- Don't return session name and let mini.session infer current session name.
    -- Even if session name matches - session FD is locked by mini.files and file isn't writable.
    cb(nil)
    return
  end

  local input_opts = {
    prompt = 'Enter a new session name (optional): ',
    default = MiniSessions.config.file,
  }

  prompt_input(input_opts, function(result)
    if not result then
      -- Prompt dismissed.
      return
    end

    -- If empty, save as a local session.
    local is_local = result == '' or result == MiniSessions.config.file
    if result == '' then
      result = MiniSessions.config.file
    end

    cb(result, is_local)
  end)
end

--- @class MiniWorkspaces.UI.SaveSessionOpts
--- @field force boolean|nil
--- @field verbose boolean|nil

--- Shows a prompt to save current session.
---
--- If provided session name is empty, saves as a local session.
---
--- @param opts MiniWorkspaces.UI.SaveSessionOpts|nil
M.save_session_dialog = function(opts)
  prompt_session_name(function(name, is_local)
    if not name or not is_local then
      -- Save global session or update the current one.
      require('mini.sessions').write(name, opts)
      return
    end

    -- Save via workspace to preserve history.
    require('pkg.mini-session-workspaces').save_workspace(nil, {
      force = opts and opts.force,
    })
  end)
end

return M
