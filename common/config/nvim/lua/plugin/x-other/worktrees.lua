local function var_dump(v)
  print(vim.inspect(v))
end

return {
  {
    'Juksuu/worktrees.nvim',
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
        on_switch = function(from, to, git_path_info)
          -- var_dump({
          --   event = 'on_switch',
          --   from = from,
          --   to = to,
          --   git_path_info = git_path_info,
          -- })
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
