local mini_plugins = {
  -- Better Around/Inside textobject
  --
  -- Examples:
  -- - va)   - [V]isual select [a]round [)]parentn
  -- - yinnq - [y]ank [i]nside [n]ext [q]uote
  -- - ci'   - [c]hange [i]nside [']quote
  ['mini.ai'] = { n_lines = 500 },

  -- Add/delete/replace surroundings (brackets, quotes, etc).
  -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
  --
  -- - saiw)  - [s]urround [a]dd [i]nner [w]ord [)]paren
  -- - sd'    - [s]urround [d]elete [']quotes
  -- - sr)'   - [s]urround [r]eplace [)][']
  ['mini.surround'] = {
    mappings = {
      add = '<Leader>za', -- Add surrounding in Normal and Visual modes
      delete = '<Leader>zd', -- Delete surrounding
      find = '<Leader>zf', -- Find surrounding (to the right)
      find_left = '<Leader>zF', -- Find surrounding (to the left)
      highlight = '<Leader>zh', -- Highlight surrounding
      replace = '<Leader>zr', -- Replace surrounding
      update_n_lines = '<Leader>zn', -- Update `n_lines`
    },
  },

  -- Highlight current indent scope.
  ['mini.indentscope'] = function(indentscope)
    return {
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
    }
  end,

  -- Move lines
  -- Defaults are Alt (Meta) + hjkl.
  ['mini.move'] = {},

  -- Custom notifications (vim.notify replacement).
  ['mini.notify'] = {
    content = {
      format = function(notif)
        if notif.data.source == 'lsp_progress' then
          return notif.msg
        end
        return MiniNotify.default_format(notif)
      end,
      -- Show more recent notifications first
      sort = function(notif_arr)
        table.sort(notif_arr, function(a, b)
          return a.ts_update > b.ts_update
        end)
        return notif_arr
      end,
    },
  },

  -- Startup screen.
  -- See: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-starter.md
  ['mini.starter'] = {
    header = function()
      return require('util.uiutil').get_header()
    end,
  },

  -- Session management. Works with mini.starter
  ['mini.sessions'] = {
    autoread = false,
    autowrite = true,
    file = '',
    directory = vim.fn.stdpath('data') .. '/sessions',
    force = {
      write = true,
    },
  },

  -- File explorer
  ['mini.files'] = {
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
  },
}

return {
  {
    'nvim-mini/mini.nvim',
    lazy = false,
    version = false,
    config = function()
      -- For session management
      vim.opt.sessionoptions:append('folds')
      vim.opt.sessionoptions:append('globals')
      vim.opt.sessionoptions:append('buffers')
      vim.opt.sessionoptions:append('tabpages')

      -- Notify LSP server when file is moved in mini.files.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          ---@module 'snacks'
          ---@type snacks.plugins
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })

      for modname, params in pairs(mini_plugins) do
        local mod = require(modname)
        local cfg = params
        if type(cfg) == 'function' then
          cfg = cfg(mod)
        end

        mod.setup(cfg)
      end
    end,
    dependencies = {
      -- For ascii art
      'MaximilianLloyd/ascii.nvim',
      'MunifTanjim/nui.nvim',
    },
  },
}
