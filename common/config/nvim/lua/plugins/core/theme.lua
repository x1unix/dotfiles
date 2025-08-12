local config = require('config.theme')

-- Global lualine opts
local lualine_opts = {
  -- Disable in neotree
  disabled_filetypes = { 'neo-tree', 'Trouble' },
}

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
      if type(config.setup) == 'function' then
        config.setup()
      end

      local darkmode = config.darkmode
      if type(darkmode) == 'table' and not os.is_android() then
        require('auto-dark-mode').setup(darkmode)
      end

      require('lualine').setup({
        options = vim.tbl_deep_extend('force', lualine_opts, config.lualine),
      })
      vim.opt.showmode = false
    end,
  },
}
