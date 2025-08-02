local M = {}

-- Returns session name to use for save.
--
-- If [vim.v.this_session] is empty - prompts a session name
-- or uses [vim.fn.getwd] as fallback.
M.prompt_session_name = function()
  local current_name = vim.v.this_session
  if current_name and current_name ~= '' then
    -- Don't return session name and let mini.session infer current session name.
    -- Even if session name matches - session FD is locked by mini.files and file isn't writable.
    return nil
  end

  current_name = vim.fn.input('Enter a new session name (optional): ')
  if current_name and current_name ~= '' then
    return current_name
  end

  -- Try guess from a current workdir if empty
  return vim.fn.getcwd():gsub('[\\/]', '__')
end

return M
