local config = require('config.theme')

-- Global lualine opts
local lualine_opts = {
  -- Disable in neotree
  disabled_filetypes = { 'neo-tree', 'Trouble' },
}

local darkmode_init = false
local function darkmode_hook(style)
  -- FIXME: reload bufferline highlights on theme change.
  if darkmode_init then
    config.on_dark_mode_change(style)
    vim.cmd('doautocmd ColorScheme')
    return
  end

  darkmode_init = true
  if type(config.setup) == 'function' then
    config.setup(style)
    vim.cmd('doautocmd ColorScheme')
  end
end

-- Theme and automatic dark&light mode support
return {
  {
    config.package,
    lazy = false,
    priority = 9999,
    dependencies = {
      'f-person/auto-dark-mode.nvim',
      'nvim-lualine/lualine.nvim',
    },
    config = function()
      local os = require('util.os')
      -- On startup, plugin fires first event immediately with current theme.
      -- Call setup during that time.
      if type(config.on_dark_mode_change) == 'function' and not os.is_android() then
        require('auto-dark-mode').setup({
          fallback = 'dark',
          update_interval = 1000,
          set_dark_mode = function()
            darkmode_hook('dark')
          end,
          set_light_mode = function()
            darkmode_hook('light')
          end,
        })
      else
        config.setup('dark')
      end

      require('lualine').setup({
        options = vim.tbl_deep_extend('force', lualine_opts, config.lualine),
      })
      vim.opt.showmode = false
    end,
  },
}
