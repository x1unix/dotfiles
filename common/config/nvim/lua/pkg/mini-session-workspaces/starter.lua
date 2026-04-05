local M = {}

--- @param msg string
local function placeholder_entry(msg)
  return {
    {
      name = msg,
      action = '',
      section = 'Workspaces',
    },
  }
end

-- Returns workspaces list section for mini.starter
M.workspaces = function()
  local workspaces = require('pkg.mini-session-workspaces')
  if not workspaces._ready then
    return placeholder_entry([[Workspaces plugin is not set up]])
  end

  local entries = workspaces.history()
  if not entries or #entries == 0 then
    return placeholder_entry([[History is empty]])
  end

  local out = {}

  local sections = vim.tbl_map(function(entry)
    return {
      name = entry.label,
      action = 'MiniWorkspaces ' .. vim.fn.fnameescape(entry.path),
      section = 'Workspaces',
    }
  end, entries)
  return sections
end

return M
