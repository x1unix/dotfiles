return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    version = false,
    keys = {
      { '<leader>e', '<cmd>:lua MiniFiles.open()<CR>', desc = 'mini.files' },
    },
    config = function()
      require('mini.tabline').setup({
        -- tabpage_section = 'none',
      })

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
      --require('mini.surround').setup()
      -- TODO: 's' key conflicts with flash.nvim. Figure out other binding.

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

      -- Notify LSP server when file is moved in mini.files.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
  },
}
