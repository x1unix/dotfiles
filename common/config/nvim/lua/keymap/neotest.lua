local function run_test(args)
  local nt = require("neotest")
  -- very buggy
  -- nt.output_panel.clear()
  nt.output_panel.open()
  require("neotest").run.run(args)
end

local function test_file()
  require("neotest").summary.open()
  run_test(vim.fn.expand("%"))
end

local function close_panel()
  local nt = require("neotest")
  nt.output_panel.clear()
  nt.output_panel.close()
end

-- Hotkeys
-- See: https://github.com/nvim-neotest/neotest
require("which-key").add({
  { "<Leader>t", group = "neotest", mode = "n", },
  {
    "<Leader>tt", function() run_test() end,
    desc = "run the nearest test",
  },
  {
    "<Leader>tf", test_file,
    desc = "run the current file",
  },
  {
    "<Leader>td", function() run_test({strategy = "dap"}) end,
    desc = "debug nearest test",
  },
  {
    "<Leader>tq", function() require("neotest").run.stop() end,
    desc = "stop test execution",
  },
  {
    "<Leader>tT", function() require("neotest").run.attach() end,
    desc = "attatch to a nearest test",
  },
  {
    "<Leader>tV", function() require("neotest").summary.toggle() end,
    desc = "toggle summary window",
  },
  {
    "<Leader>tv", function() require("neotest").output_panel.toggle() end,
    desc = "toggle test output panel",
  },
  {
    "<Leader>tvv", close_panel,
    desc = "close test output panel and clear",
  },
})



