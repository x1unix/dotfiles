return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
    },
  },
}
