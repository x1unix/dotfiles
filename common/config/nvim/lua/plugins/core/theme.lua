local config = require('config.theme')
-- Theme and automatic dark&light mode support
return {
  {
    config.package,
    lazy = false,
    priority = 1000,
    dependencies = {
      'f-person/auto-dark-mode.nvim',
      'nvim-lualine/lualine.nvim',
    },
    config = function()
      if type(config.setup) == 'function' then
        config.setup()
      end

      local darkmode = config.darkmode
      if type(darkmode) == 'table' then
        require('auto-dark-mode').setup(darkmode)
      end

      require('lualine').setup(config.lualine)
      vim.opt.showmode = false
    end,
  },
}
