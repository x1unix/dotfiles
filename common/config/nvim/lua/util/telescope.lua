-- In Telescope source code, actions are combined with '+' operator.
-- It should work for cases when there is an Action object + function, e.g:
--    actions.send_to_loclist + actions.open_loclist
--
-- For some reason, this "magic" doesn't work with custom functions.
-- Thus, I have to wrap and call parent action manually.
--
-- P.S - Although in code, builtins are tables. In runtime - they're weird callbable values. WTF?
local M = {
  actions = {},
}

M.actions.send_to_qflist = function(bufnr)
  require('telescope.actions').send_to_qflist(bufnr)
  require('trouble').open({
    mode = 'quickfix',
    focus = true,
    pinned = true,
    new = true,
  })
end

M.actions.send_to_loclist = function(bufnr)
  require('telescope.actions').send_to_loclist(bufnr)
  require('trouble').open({
    mode = 'loclist',
    focus = true,
    pinned = true,
    new = true,
  })
end

M.actions.destroy_buffer = function(prompt_bufnr)
  -- See: https://github.com/razak17/telescope.nvim/blob/master/lua/telescope/actions/init.lua#L826
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  picker:delete_selection(function(selection)
    vim.api.nvim_buf_delete(selection.bufnr, { force = true })
    vim.notify('Buffer wiped: ' .. selection.filename or selection.bufnr, vim.log.levels.INFO, {
      opts = { duration = 1000 },
    })
  end)
end

return M
