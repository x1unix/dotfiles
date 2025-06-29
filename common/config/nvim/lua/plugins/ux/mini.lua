return {
  {
    'echasnovski/mini.nvim',
    version = false,
    keys = {
      { '<leader>e', '<cmd>:lua MiniFiles.open()<CR>', desc = 'mini.files' },
    },
    config = function()
      -- Better Around/Inside textobject
      --
      -- Examples:
      -- - va)   - [V]isual select [a]round [)]parentn
      -- - yinnq - [y]ank [i]nside [n]ext [q]uote
      -- - ci'   - [c]hange [i]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc).
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
      --
      -- - saiw)  - [s]urround [a]dd [i]nner [w]ord [)]paren
      -- - sd'    - [s]urround [d]elete [']quotes
      -- - sr)'   - [s]urround [r]eplace [)][']
      require('mini.surround').setup()

      require('mini.files').setup({
        content = {
          filter = function(name)
            local blocked = {
              ['__pycache__'] = true,
              ['venv'] = true,
              ['.venv'] = true,
              ['.pytest_cache'] = true,
              ['.git'] = true,
              ['.idea'] = true,
            }
            return not blocked[name.name]
          end,
        },
      })

      require('mini.tabline').setup({
        tabpage_section = 'none',
      })
    end,
  },
}
