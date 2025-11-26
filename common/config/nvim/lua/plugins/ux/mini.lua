return {
  {
    'nvim-mini/mini.nvim',
    lazy = false,
    version = false,
    keys = {
      {
        '<leader>e',
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
          ---@module 'mini.files'
          ---@type mini.files.MiniFiles
          MiniFiles.open(path)
          MiniFiles.reveal_cwd()
        end,
        desc = 'mini.files',
      },
    },
    config = function()
      -- Startup screen.
      -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter.md
      require('mini.starter').setup({
        header = function()
          return require('util.uiutil').get_header()
        end,
      })

      -- require('mini.tabline').setup({
      --   -- tabpage_section = 'none',
      -- })

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
      require('mini.surround').setup({
        mappings = {
          add = '<Leader>za', -- Add surrounding in Normal and Visual modes
          delete = '<Leader>zd', -- Delete surrounding
          find = '<Leader>zf', -- Find surrounding (to the right)
          find_left = '<Leader>zF', -- Find surrounding (to the left)
          highlight = '<Leader>zh', -- Highlight surrounding
          replace = '<Leader>zr', -- Replace surrounding
          update_n_lines = '<Leader>zn', -- Update `n_lines`
        },
      })

      -- Highlight current indent scope.
      local indentscope = require('mini.indentscope')
      indentscope.setup({
        symbol = '▎',
        draw = {
          delay = 0,
          animation = indentscope.gen_animation.none(),
        },
        mappings = {
          -- Textobjects
          object_scope = 'ii',
          object_scope_with_border = 'ai',

          -- Motions (jump to respective border line; if not present - body line)
          goto_top = '[i',
          goto_bottom = ']i',
        },
        options = {
          indent_at_cursor = true,
        },
      })

      -- Move lines
      -- Defaults are Alt (Meta) + hjkl.
      require('mini.move').setup()

      -- Custom notifications (vim.nofify replacement).
      require('mini.notify').setup({
        content = {
          format = function(notif)
            return notif.msg
            -- if notif.data.source == 'lsp_progress' then
            --   return notif.msg
            -- end
            -- return MiniNotify.default_format(notif)
          end,
          -- Show more recent notifications first
          sort = function(notif_arr)
            table.sort(notif_arr, function(a, b)
              return a.ts_update > b.ts_update
            end)
            return notif_arr
          end,
        },
      })

      -- Session management
      vim.opt.sessionoptions:append('folds')
      vim.opt.sessionoptions:append('globals')
      require('mini.sessions').setup({
        autoread = true,
        autowrite = true,
        file = '',
        directory = vim.fn.stdpath('data') .. '/sessions',
        force = {
          write = true,
        },
      })

      -- FIle Explorer
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
        windows = {
          preview = true,
          width_preview = 50,
        },
      })

      -- Notify LSP server when file is moved in mini.files.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          ---@module 'snacks'
          ---@type snacks.plugins
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
    dependencies = {
      -- For ascii art
      'MaximilianLloyd/ascii.nvim',
      'MunifTanjim/nui.nvim',
    },
  },
}
