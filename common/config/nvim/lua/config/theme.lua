local ts = require('util.treesitter')

local function vscode_switch_style(style)
  -- Plugin resets file syntax after switch and breaks syntax highlight.
  -- Restore syntax after switch
  local filetype = vim.bo.filetype
  require('vscode').load(style)

  if filetype and filetype ~= '' then
    vim.cmd('setlocal filetype=' .. filetype)
  end
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
    options = {
      icons_enabled = true,
      theme = 'vscode',
    },
  },

  -- Auto-dark-mode options
  darkmode = {
    update_interval = 1000,
    set_dark_mode = function()
      vscode_switch_style('dark')
    end,
    set_light_mode = function()
      vscode_switch_style('light')
    end,
  },

  -- Called after theming plugins loaded
  setup = function()
    require('vscode').setup({ style = 'dark' })
    ts.install_reload_highlights_autocmd()
    vim.cmd.colorscheme('vscode')
  end,
}
