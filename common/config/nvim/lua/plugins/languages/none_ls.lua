return {
  {
    'nvimtools/none-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      local cfg = require('config.languages.null_ls').get_config(null_ls)
      null_ls.setup(cfg)
    end,
  },
}
