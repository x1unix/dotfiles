local M = {}

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

return M
