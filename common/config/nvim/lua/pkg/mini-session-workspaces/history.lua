--- @class MiniWorkspaces.History.Entry
--- @field label string History entry label.
--- @field path string Absolute workspace directory path.
--- @field mod_time number Last access time.
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
  --- In-memory list of entries pulled from a file sorted by "mod_time".
  _entries = nil,

  --- @type table<string, number> Index of entries to find index by path.
  _index = nil,
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
  -- TODO: parse JSON and load into "_entries" and initialize "_index",
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

--- Returns history entries.
---
--- @return table<MiniWorkspaces.History.Entry>|nil
function History:entries()
  return self._entries
end

--- Adds a new entry to history
--- @param path string
--- @param metadata table|nil
function History:add(path, metadata)
  local label = vim.fn.fnamemodify(path, ':t')

  --- @type MiniWorkspaces.History.Entry
  local entry = {
    label = label,
    path = path,
    mod_time = os.time(),
    metadata = metadata,
  }

  -- TODO: insert/replace entry
end

--- Updates entry access time.
--- @param path string
--- @return boolean Whetner entry was updated. False if not found.
function History:touch(path)
  -- TODO: implement. Get entry and update its access time.
  return false
end

--- Save history to disk.
function History:sync()
  -- TODO: implement. Persist data to _fname. Data might be outdated if file's actual modtime is newer than this._modtime.
end

--- @param path string Path of history entry
function History:delete(path)
  -- TODO: implement. Silently return if path doesn't exist.
end

return History
