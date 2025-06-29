return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "buffer local keymaps (which-key)",
    },
    config = function()
      local wk = require("which-key")
      wk.setup({})
      require("keymap")
    end
  },
}
