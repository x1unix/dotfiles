return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-endwise',
      'windwp/nvim-ts-autotag',
    },
    opts = function()
      local pkgs = require('config.lang_packages')
      return {
        ensure_installed = pkgs.languages,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
              ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
          },
          matchup = {
            enable = true,
          },
          endwise = {
            enable = true,
          },
          autotag = {
            enable = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
