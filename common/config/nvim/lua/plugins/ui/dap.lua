return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        config = function(_, opts)
          local dap, dapui = require('dap'), require('dapui')
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
        end,
      },
      {
        -- Go integration for DAP
        'leoluz/nvim-dap-go',
        config = function()
          -- See: https://github.com/leoluz/nvim-dap-go
          require('dap-go').setup()
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
      {
        -- Mason package manager adapter for DAP
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = 'mason-org/mason.nvim',
        cmd = { 'DapInstall', 'DapUninstall' },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {
            'delve',
          },
        },
      },

      -- DAP adapter for Neovim Lua debugging
      { 'jbyuki/one-small-step-for-vimkind', module = 'osv' },
    },
  },
}
