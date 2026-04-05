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
        'gW',
        mode = { 'n' },
        function()
          Snacks.picker.worktrees()
        end,
        desc = 'git: switch worktree',
      },
    },
    opts = {
      --- @module 'worktrees'
      --- @type worktrees.Hooks
      hooks = {
        on_before_switch = function(from, to, git_path_info)
          -- Persist workspace session
          require('pkg.mini-session-workspaces').save_workspace(from, {
            force = true,
            wipeout = true,
          })
        end,
        on_switch = function(from, to, git_path_info)
          -- Restore session
          require('pkg.mini-session-workspaces').open_workspace(to, {
            create_if_missing = true,
            on_created = require('util.uiutil').open_readme,
          })
        end,
        on_before_remove = function(path)
          require('pkg.mini-session-workspaces').delete_workspace(path, { force = true })
        end,
      },
    },
  },
}
