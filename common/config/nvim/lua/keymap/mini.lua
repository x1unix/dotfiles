local wk = require('which-key')

-- Leader
wk.add({
  { '<Leader>s', group = 'sessions' },
  {
    '<Leader>sl',
    function()
      require('mini.sessions').read(nil)
    end,
    mode = 'n',
    desc = 'Load local or latest global session',
  },
  {
    '<Leader>sr',
    function()
      require('mini.sessions').select('read')
    end,
    mode = 'n',
    desc = 'Pick & load session',
  },
  {
    '<Leader>ss',
    function()
      require('util.sessionutil').prompt_session_name(function(session_name)
        require('mini.sessions').write(session_name, { force = true })
      end)
    end,
    mode = 'n',
    desc = 'Save current session',
  },
  {
    '<Leader>sd',
    function()
      require('mini.sessions').select('delete', { force = true })
    end,
    mode = 'n',
    desc = 'Select & delete a session',
  },
})

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in({ close_on_file = true })
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = 'Split ' .. direction
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

-- Extra binds for mini.files
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local bufnr = args.data.buf_id

    -- Open selected file in split
    map_split(bufnr, '<C-s>', 'belowright horizontal')
    map_split(bufnr, '<C-v>', 'belowright vertical')
    vim.keymap.set('n', '<C-t>', function()
      -- Tried to adapt vsplit example from mini.files docs with 'tabe' - didn't work :(
      local entry = MiniFiles.get_fs_entry()
      if not entry then
        return vim.notify('Cursor is not on valid entry')
      end
      if entry.fs_type == 'file' then
        MiniFiles.close()
        vim.cmd('tabedit ' .. vim.fn.fnameescape(entry.path))
      else
        -- if it's a directory, just go in normally
        MiniFiles.go_in()
      end
    end, { buffer = bufnr, desc = 'Open in a new window' })

    -- Grep in selected dir
    vim.keymap.set('n', '<C-/>', function()
      local entry = MiniFiles.get_fs_entry()
      if not entry then
        return vim.notify('Cursor is not on valid entry')
      end

      local target_dir = entry.path
      -- If cursor over file - grep in dir.
      if entry.fs_type ~= 'directory' then
        target_dir = vim.fs.dirname(target_dir)
      end

      MiniFiles.close()
      require('telescope.builtin').live_grep({
        cwd = target_dir,
      })
      vim.print(target_dir)
    end, { buffer = bufnr, desc = 'Grep in selected directory' })
  end,
})
