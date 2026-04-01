local formatters = require('config.formatters')

-- conform: formatting plugin.
-- see: https://github.com/stevearc/conform.nvim
return {
  {
    'stevearc/conform.nvim',
    opts = formatters,
  },
}
