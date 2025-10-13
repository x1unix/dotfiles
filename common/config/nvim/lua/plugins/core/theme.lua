local config = require('config.theme')

local lualine_config = {
  options = {
    -- Disable in neotree
    disabled_filetypes = { 'neo-tree', 'Trouble' },
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}

local function reload_bufferline_highlights()
  --FIXME: hack, unreliable.
  --See: https://github.com/akinsho/bufferline.nvim/issues/1030
  local all_highlights = vim.api.nvim_get_hl(0, {})

  for name, _ in pairs(all_highlights) do
    if name:match('^BufferLine') then
      vim.api.nvim_set_hl(0, name, {})
    end
  end

  local kfg = require('bufferline.config')
  kfg.update_highlights()
end

local darkmode_init = false
local function darkmode_hook(style)
  if darkmode_init then
    config.on_dark_mode_change(style)
    vim.cmd('doautocmd ColorScheme')
    reload_bufferline_highlights()
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
        options = vim.tbl_deep_extend('force', lualine_config.options, config.lualine),
        sections = lualine_config.sections,
      })
      vim.opt.showmode = false
    end,
  },
}
