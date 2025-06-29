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

      -- See: https://github.com/folke/which-key.nvim
      wk.setup({})

      -- Note: some hotkeys are defined in plugins/*.lua
      require("keymap.global")
      require("keymap.ufo")
      require("keymap.telescope")
      require("keymap.lsp")
      require("keymap.dap")
      require("keymap.neotest")
    end
  },
}
