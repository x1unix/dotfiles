local dap, dapui = require("dap"), require("dapui")
dapui.setup()

-- Sync dap-ui with dap state.
-- See ":help dap-extensions"
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Essential hotkeys. See ':help dap-mappings'
local wk = require("which-key")
wk.add({
    { "<leader>d", group = "dap" },
    {
      "<F5>", function() require("dap").continue() end,
      desc = "Launch configuration", mode = "n",
    },
    {
      "<F10>", function() require("dap").step_over() end,
      desc = "Step over", mode = "n",
    },
    {
      "<F11>", function() require("dap").step_into() end,
      desc = "Step into", mode = "n",
    },
    {
      "<F12>", function() require("dap").step_out() end,
      desc = "Step out", mode = "n",
    },
    {
      "<Leader>dd", function() require("dap").continue() end,
      desc = "Launch configuration", mode = "n",
    },
    {
      "<Leader>dR", function() require("dap").restart() end,
      desc = "Restart current session", mode = "n",
    },
    {
      "<Leader>dr", function() require("dap").run_last() end,
      desc = "Run last debug configuration", mode = "n",
    },
    {
      "<Leader>dq", function() require("dap").terminate() end,
      desc = "Terminate debug session", mode = "n",
    },
    {
      "<Leader>db", function() require("dap").toggle_breakpoint() end,
      desc = "Toggle breakpoint", mode = "n",
    },
    {
      "<Leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition:"), nil, nil) end,
      desc = "Add conditional breakpoint", mode = "n",
    },
    {
      "<Leader>dlb", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
      desc = "Add log breakpoint", mode = "n",
    },
    {
      "<Leader>dr", function() require("dap").repl.open() end,
      desc = "Open REPL", mode = "n",
    },
    {
      "<Leader>d:", function() require("dap").repl.open() end,
      desc = "List breakpoints", mode = "n",
    },
    -- See: https://github.com/rcarriga/nvim-dap-ui
    {
      "<Leader>ds",
      function()
       local widgets = require("dap.ui.widgets")
       widgets.centered_float(widgets.frames)
      end,
      desc = "UI: stack frames", mode = "n",
    },
    {
      "<Leader>ds",
      function()
       local widgets = require("dap.ui.widgets")
       widgets.centered_float(widgets.scopes)
      end,
      desc = "UI: variable scopes", mode = "n",
    },
    {
      "<Leader>dh",
      function()
       require("dap.ui.widgets").hover()
      end,
      desc = "UI: hover", mode = {"n", "v"},
    },
    {
      "<Leader>dp",
      function()
       require("dap.ui.widgets").preview()
      end,
      desc = "UI: preview", mode = {"n", "v"},
    },
})

