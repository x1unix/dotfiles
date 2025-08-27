return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    version = '^1.0.0',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      enable = true,
      multiwindow = true,
    },
  },
}
