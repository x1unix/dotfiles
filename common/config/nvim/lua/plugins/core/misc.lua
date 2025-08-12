return {
  {
    'numToStr/Comment.nvim',
    lazy = false,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    lazy = false,

    ---@module "ibl"
    ---@type ibl.config
    opts = {
      -- See ':highlight' command.
      -- indent = {
      --   highlight = highlight,
      -- },
      -- whitespace = {
      --   highlight = highlight,
      -- },
      -- scope = {
      --   highlight = highlight,
      -- },
    },
  },
}
