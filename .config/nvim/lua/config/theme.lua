local darkmode = require('auto-dark-mode')
local vscode = require('vscode')
local lualine = require('lualine')

local function vscode_switch_style(style)
  -- Plugin resets file syntax after switch and breaks syntax highlight.
  -- Restore syntax after switch
  local filetype = vim.bo.filetype
  vscode.load(style)

  if filetype and filetype ~= "" then
    vim.cmd("setlocal filetype=" .. filetype)
  end
end

local function init_theme()
  vscode.setup({ style = 'light' })
  vim.cmd.colorscheme = 'vscode'

  darkmode.setup({
    update_interval = 1000,
    set_dark_mode = function()
      vscode_switch_style('dark')
    end,
    set_light_mode = function ()
      vscode_switch_style('light')
    end,
  })
end

local function init_lualine()
  -- See: https://github.com/nvim-lualine/lualine.nvim
  lualine.setup({
    options = {
      icons_enabled = true,
      theme = 'vscode',
    },
  })
end

local function init()
  init_theme()
  init_lualine()
end

init()

