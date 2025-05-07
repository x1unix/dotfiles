require("lazydev").setup({
  debug = nil,
  runtime = vim.env.VIMRUNTIME,
  library = { "nvim-dap-ui", "neotest" },
  integrations = {
    lspconfig = true,
    cmp = true,
  },
  enabled = function(root_dir)
        return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end,
})

require("core")
require("plugins")
require("hotkeys")
require("languages")

