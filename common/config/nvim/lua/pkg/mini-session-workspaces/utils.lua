local M = {}

M.new_session = function(session_path, session_type)
  return {
    modify_time = vim.fn.getftime(session_path),
    name = vim.fn.fnamemodify(session_path, ':t'),
    path = session_path,
    type = session_type,
  }
end

M.get_unsaved_listed_buffers = function()
  return vim.tbl_filter(function(buf_id)
    return vim.bo[buf_id].modified and vim.bo[buf_id].buflisted
  end, vim.api.nvim_list_bufs())
end

M.assert_has_unsaved_buffers = function(msg)
  local unsaved_buffs = M.get_unsaved_listed_buffers()
  if #unsaved_buffs == 0 then
    return true
  end

  vim.notify(('%s, there are %d unsaved buffers.'):format(#unsaved_buffs, msg), vim.log.levels.ERROR)
  return false
end

--- Closes all buffers and terminates LSP servers.
M.dispose_workspace = function()
  vim.cmd('clearjumps | silent! %bwipeout!')
  vim.lsp.stop_client(vim.lsp.get_clients())
  vim.v.this_session = ''
end

return M
