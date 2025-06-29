local pkgs = require('config.lang_packages')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = pkgs.languages,
    },
  },
}
