--- @class MiniWorkspaces.History.Entry
--- @field label string History entry label.
--- @field path string Absolute workspace directory path.
--- @field mod_time number Last access time.
--- @field metadata table|nil Additional metadata.

--- @class MiniWorkspaces.History.File
--- @field entries table<MiniWorkspaces.History.Entry>|nil List of entries.

local SYNC_DEBOUNCE_MS = 120

--- Module implements workspace history tracking
local History = {
  _fname = '',
  _limit = 0,

  --- History file mod time.
  --- Used to check whether history file is outdated before flush.
  _modtime = 0,

  --- @type table<MiniWorkspaces.History.Entry>|nil
  --- In-memory list of entries pulled from a file sorted by "mod_time" (desc).
  _entries = nil,

  --- @type table<string, number> Index of entries to find index by path.
  _index = nil,

  --- @type number Monotonic id for deferred sync scheduling.
  _sync_seq = 0,

  --- @type boolean Whether in-memory entries differ from on-disk state.
  _dirty = false,
}

History.__index = History

--- @param entries table<MiniWorkspaces.History.Entry>
--- @return table<string, number>
local function build_index(entries)
  local index = {}
  for i, entry in ipairs(entries) do
    index[entry.path] = i
  end

  return index
end

--- @param a MiniWorkspaces.History.Entry
--- @param b MiniWorkspaces.History.Entry
--- @return boolean
local function is_entry_before(a, b)
  if a.mod_time == b.mod_time then
    return a.path < b.path
  end

  return a.mod_time > b.mod_time
end

--- @param path string
--- @return string
local function path_label(path)
  return vim.fn.fnamemodify(path, ':t')
end

--- @param item unknown
--- @return MiniWorkspaces.History.Entry|nil
local function normalize_entry(item)
  if type(item) ~= 'table' or type(item.path) ~= 'string' or #item.path == 0 then
    return nil
  end

  return {
    label = type(item.label) == 'string' and item.label or path_label(item.path),
    path = item.path,
    mod_time = tonumber(item.mod_time) or 0,
    metadata = type(item.metadata) == 'table' and item.metadata or nil,
  }
end

--- @class db History
local function queue_sync(db)
  db._sync_seq = (db._sync_seq or 0) + 1
  local seq = db._sync_seq

  vim.defer_fn(function()
    if db._sync_seq ~= seq then
      return
    end

    vim.schedule(function()
      db:sync()
    end)
  end, SYNC_DEBOUNCE_MS)
end

--- @class db History
local function pull_history(db)
  if db._dirty then
    return
  end

  if vim.fn.filereadable(db._fname) ~= 1 then
    db._modtime = 0
    db._entries = nil
    db._index = {}
    db._dirty = false
    return
  end

  local modtime = vim.fn.getftime(db._fname)
  if modtime == db._modtime and db._index ~= nil then
    return
  end

  local entries = {}
  local seen = {}

  local ok, payload = pcall(vim.fn.json_decode, vim.fn.readfile(db._fname))
  if ok and type(payload) == 'table' then
    local source_entries = payload.entries
    if vim.islist(payload) then
      source_entries = payload
    end

    if vim.islist(source_entries) then
      for _, item in ipairs(source_entries) do
        local entry = normalize_entry(item)
        if entry ~= nil and not seen[entry.path] then
          seen[entry.path] = true
          table.insert(entries, entry)
        end
      end
    end
  end

  table.sort(entries, is_entry_before)

  if db._limit > 0 and #entries > db._limit then
    entries = vim.list_slice(entries, 1, db._limit)
  end

  db._entries = #entries > 0 and entries or nil
  db._index = #entries > 0 and build_index(entries) or {}
  db._modtime = modtime
  db._dirty = false
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
  pull_history(self)

  local label = path_label(path)
  local entries = self._entries or {}

  if not self._entries then
    self._entries = entries
  end

  local existing_idx = self._index and self._index[path] or nil
  if existing_idx then
    table.remove(entries, existing_idx)
  end

  --- @type MiniWorkspaces.History.Entry
  local entry = {
    label = label,
    path = path,
    mod_time = os.time(),
    metadata = metadata,
  }

  table.insert(entries, 1, entry)
  if self._limit > 0 and #entries > self._limit then
    entries = vim.list_slice(entries, 1, self._limit)
  end

  self._entries = entries
  self._index = build_index(entries)
  self._dirty = true
  queue_sync(self)
end

--- Updates entry access time.
--- @param path string
--- @return boolean Whetner entry was updated. False if not found.
function History:touch(path)
  pull_history(self)

  if not self._entries or not self._index[path] then
    return false
  end

  local idx = self._index[path]
  local entry = table.remove(self._entries, idx)
  entry.mod_time = os.time()

  table.insert(self._entries, 1, entry)
  self._index = build_index(self._entries)
  self._dirty = true
  queue_sync(self)
  return true
end

--- Save history to disk.
function History:sync()
  if not self._dirty then
    return true
  end

  local current_modtime = vim.fn.getftime(self._fname)
  if current_modtime > self._modtime then
    return false
  end

  local parent_dir = vim.fs.dirname(self._fname)
  if #parent_dir > 0 then
    vim.fn.mkdir(parent_dir, 'p')
  end

  local payload = {
    entries = self._entries,
  }

  vim.fn.writefile({ vim.fn.json_encode(payload) }, self._fname)
  self._modtime = vim.fn.getftime(self._fname)
  self._dirty = false
  return true
end

--- @param path string Path of history entry
function History:delete(path)
  pull_history(self)

  if not self._entries or not self._index[path] then
    return
  end

  table.remove(self._entries, self._index[path])
  if #self._entries == 0 then
    self._entries = nil
    self._index = {}
  else
    self._index = build_index(self._entries)
  end

  self._dirty = true
  queue_sync(self)
end

return History
