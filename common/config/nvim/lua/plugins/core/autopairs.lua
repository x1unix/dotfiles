return {
  {
    -- Automatically add pairs (brackets, quotes, etc).
    --
    -- See: https://github.com/windwp/nvim-autopairs
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      check_ts = true,
      disable_filetype = require('util.typeutil').ignored_plugin_filetypes,
    },
  },
}
