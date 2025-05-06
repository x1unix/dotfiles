-- See: https://github.com/ray-x/go.nvim
require("go").setup()

-- See: https://github.com/leoluz/nvim-dap-go
require("dap-go").setup {
  dap_configurations = {
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
    {
      type = "go",
      name = "Debug current file with arguments",
      request = "launch",
      program = "${file}",
      args = require("dap-go").get_arguments,
    },
  },
  delve = {
    path = "dlv",
    initialize_timeout_sec = 20,
    port = "${port}",
    args = {}, -- extra delve args
    build_flags = {}, -- extra build flags passed to delve
    detached = vim.fn.has("win32") == 0,
    cwd = nil, -- custom workdir
    tests = {
      verbose = false,
    },
  },
}
