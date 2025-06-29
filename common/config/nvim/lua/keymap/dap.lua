-- Essential hotkeys. See ':help dap-mappings'
--
-- * https://github.com/rcarriga/nvim-dap-ui
-- * https://github.com/nvim-telescope/telescope-dap.nvim
local wk = require('which-key')
wk.add({
  -- Hotkeys inspired by GoLand/IntelliJ
  {
    '<F5>',
    function()
      require('dap').continue()
    end,
    desc = 'launch configuration',
    mode = 'n',
    group = 'dap',
  },
  {
    '<F8>',
    function()
      require('dap').step_over()
    end,
    desc = 'step over',
    mode = 'n',
    group = 'dap',
  },
  {
    '<F7>',
    function()
      require('dap').step_into()
    end,
    desc = 'step into',
    mode = 'n',
    group = 'dap',
  },
  {
    -- <S-F8> doesn't work for some reason.
    '<F9>',
    function()
      require('dap').step_out()
    end,
    desc = 'step out',
    mode = 'n',
    group = 'dap',
  },
})

wk.add({
  { '<Leader>d', group = 'dap' },
  {
    --   "<Leader>dd", function() require("dap").continue() end,
    '<Leader>dd',
    function()
      require('telescope').extensions.dap.configurations({})
    end,
    desc = 'debug',
    mode = 'n',
  },
  {
    '<Leader>dR',
    function()
      require('dap').restart()
    end,
    desc = 'restart current session',
    mode = 'n',
  },
  {
    '<Leader>dr',
    function()
      require('dap').run_last()
    end,
    desc = 'run last debug configuration',
    mode = 'n',
  },
  {
    '<Leader>dq',
    function()
      require('dap').terminate()
    end,
    desc = 'terminate debug session',
    mode = 'n',
  },
  {
    '<Leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'toggle breakpoint',
    mode = 'n',
  },
  {
    '<Leader>dB',
    function()
      require('dap').set_breakpoint(vim.fn.input('Breakpoint condition:'), nil, nil)
    end,
    desc = 'add conditional breakpoint',
    mode = 'n',
  },
  {
    '<Leader>dlb',
    function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    desc = 'add log breakpoint',
    mode = 'n',
  },
  {
    '<Leader>dr',
    function()
      require('dap').repl.open()
    end,
    desc = 'open REPL',
    mode = 'n',
  },
  {
    '<Leader>d/',
    function()
      require('telescope').extensions.dap.commands({})
    end,
    desc = 'commands',
    mode = 'n',
  },
  {
    -- "<Leader>d:", function() require("dap").list_breakpoints() end,
    '<Leader>d:',
    function()
      require('telescope').extensions.dap.list_breakpoints({})
    end,
    desc = 'list breakpoints',
    mode = 'n',
  },

  {
    '<Leader>ds',
    function()
      -- local widgets = require("dap.ui.widgets")
      -- widgets.centered_float(widgets.frames)
      require('telescope').extensions.dap.frames({})
    end,
    desc = 'stack frames',
    mode = 'n',
  },
  {
    '<Leader>ds',
    function()
      require('telescope').extensions.dap.variables({})
      -- local widgets = require("dap.ui.widgets")
      -- widgets.centered_float(widgets.scopes)
    end,
    desc = 'variable scopes',
    mode = 'n',
  },
  {
    '<Leader>dh',
    function()
      require('dap.ui.widgets').hover()
    end,
    desc = 'ui: hover',
    mode = { 'n', 'v' },
  },
  {
    '<Leader>dp',
    function()
      require('dap.ui.widgets').preview()
    end,
    desc = 'ui: preview',
    mode = { 'n', 'v' },
  },
})
