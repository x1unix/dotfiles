return {
  { 'lewis6991/gitsigns.nvim' },
  {
    'f-person/git-blame.nvim',
    opts = {
      enabled = false,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',

      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
      'echasnovski/mini.pick',
      'folke/snacks.nvim',
    },
  },
}
