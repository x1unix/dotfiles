local function var_dump(v)
  print(vim.inspect(v))
end

return {
  {
    -- Switch to upstream when merged: https://github.com/Juksuu/worktrees.nvim/pull/11
    -- 'Juksuu/worktrees.nvim',
    'x1unix/worktrees.nvim',
    branch = 'feat/on-before-switch',
    keys = {
      {
        '<Leader>a',
        mode = { 'n' },
        function()
          Snacks.picker.worktrees()
        end,
      },
    },
    opts = {
      --- @module 'worktrees.nvim'
      --- @type worktrees.Hooks
      hooks = {
        on_add = function(name, path, branch)
          -- TODO: handle action
          var_dump({
            event = 'on_add',
            name = name,
            path = path,
            branch = branch,
          })
        end,
        on_before_switch = function(from, to, git_path_info)
          -- Persist workspace session
          require('util.sessionutil').save_dir_session(from, {
            force = true,
            wipeout = true,
          })
        end,
        on_switch = function(from, to, git_path_info)
          -- Restore session
          require('util.sessionutil').open_dir_session(to, {
            create_if_missing = true,
            on_created = require('util.uiutil').open_readme,
          })
        end,
        on_remove = function(name)
          -- TODO: handle action
          var_dump({
            event = 'on_remove',
            name = name,
          })
        end,
      },
    },
  },
}
