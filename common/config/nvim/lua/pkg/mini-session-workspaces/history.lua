--- @class MiniWorkspaces.History.Entry
--- @field label string History entry label.
--- @field dir string Absolute workspace directory path.
--- @field metadata table|nil Additional metadata.

--- @class MiniWorkspaces.History.File
--- @field entries table<MiniWorkspaces.History.Entry>|nil List of entries.

--- Module implements workspace history tracking
local History = {
  _fname = '',
  _limit = 0,

  --- History file mod time.
  --- Used to check whether history file is outdated before flush.
  _modtime = 0,

  --- @type table<MiniWorkspaces.History.Entry>|nil
  --- In-memory list of entries pulled from a file.
  _entries = nil,
}

History.__index = History

--- @class db History
local function pull_history(db)
  if not vim.fn.filereadable(db._fname) then
    db._modtime = 0
    db._entries = nil
    return
  end

  local modtime = vim.fn.getftime(db._fname)
  -- TODO: parse JSON and load into "_entries"
end

--- Opens a workspace history database.
---
--- @param path string Path to a history json file.
--- @param limit number Max number of items in a history file.
function History:open(path, limit)
  local instance = setmetatable({}, self)
  instance._fname = path
  instance._limit = limit

  pull_history(instance)
  return instance
end

return History
