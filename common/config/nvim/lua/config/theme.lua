local ts = require('util.treesitter')

local function apply_hl()
  -- Override colors for folds
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'IblScope' })
end

-- Theme config.
-- Setup supports lualine and automatic dark/light mode switching.
--
-- Following config is used by "plugins/core/theme.lua".
return {
  -- Name of theme package to install.
  package = 'Mofiqul/vscode.nvim',

  -- Lualine options
  lualine = {
    icons_enabled = true,
    theme = 'vscode',
  },

  -- Starter screen header style.
  --
  -- See: https://github.com/MaximilianLloyd/ascii.nvim/tree/master
  starter = {
    header = function()
      return require('ascii').get_random('text', 'neovim')
    end,
  },

  -- OS dark/light mode switch hook.
  on_dark_mode_change = function(style)
    require('vscode').load(style)

    apply_hl()

    -- Plugin resets file syntax after switch and breaks syntax highlight.
    -- Restore syntax after switch
    local filetype = vim.bo.filetype
    if filetype and filetype ~= '' then
      vim.cmd('setlocal filetype=' .. filetype)
    end
  end,

  -- Initial theme setup.
  setup = function(style)
    require('vscode').setup({ style = style })
    ts.install_reload_highlights_autocmd()
    vim.cmd.colorscheme('vscode')
    apply_hl()
  end,

  -- Android-specific rules
  android = {
    starter = {
      header = function()
        return require('ascii').art.text.neovim.default1
      end,
    },
  },
}
