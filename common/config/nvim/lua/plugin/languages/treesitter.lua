---@module 'nvim-ts.parsers'
---@param parsers nvim-ts.parsers | nil
local function register_parsers(parsers)
  if not parsers then
    return
  end

  local dst = require('nvim-treesitter.parsers')
  for k, v in pairs(parsers) do
    dst[k] = v
  end
end

local function ts_get_missing()
  local ts = require('nvim-treesitter')
  local cfg = require('config.languages.grammars')

  local installed = ts.get_installed()
  if #installed == 0 then
    return cfg.grammars
  end

  local install_set = {}
  for _, v in ipairs(installed) do
    install_set[v] = true
  end

  local to_install = {}
  for _, e in ipairs(cfg.grammars) do
    if not install_set[e] then
      to_install[#to_install + 1] = e
    end
  end

  return to_install
end

local function ts_sync()
  local ts = require('nvim-treesitter')

  local to_install = ts_get_missing()
  if #to_install == 0 then
    return
  end

  vim.notify('Installing ' .. tostring(#to_install) .. ' grammars...', vim.log.levels.INFO)
  ts.install(to_install)
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- TODO: remove commit when nvim will be upgraded to v0.12
    commit = '90cd6580e720caedacb91fdd587b747a6e77d61f',
    lazy = false,
    build = ':TSUpdate | TSSync',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
      'RRethy/nvim-treesitter-endwise',
      'windwp/nvim-ts-autotag',
    },
    opts = function()
      -- Add helper to install missing grammars
      vim.api.nvim_create_user_command('TSSync', ts_sync, { nargs = 0, desc = 'Install missing TreeSitter grammars' })
      -- Load extra parsers after load
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          local cfg = require('config.languages.grammars')
          register_parsers(cfg.parsers)
        end,
      })

      return {
        install_dir = vim.fn.stdpath('data') .. '/site',
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
      require('nvim-treesitter').setup(opts)

      -- Since nvim v0.11 and treesitter 'main' branch, ensure_installed doesn't work.
      -- Manually ensure that grammars are installed.
      --
      -- P.S - What a shame. This is why we can't have nice things.
      ts_sync()
    end,
  },
}
