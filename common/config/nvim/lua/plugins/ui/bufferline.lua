return {
  {
    'akinsho/bufferline.nvim',
    version = '^4.9.1',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    ---@module 'bufferline'
    ---@type bufferline.UserConfig
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        offsets = {
          -- Possibly dapui_stacks, bapui_breakpoints, dapui_scopes, dapui_console, dap-repl
          {
            filetype = 'neo-tree',
            text_align = 'left',
            separator = true,
          },
          {
            filetype = 'dapui_watches',
            text_align = 'left',
            separator = true,
          },
        },
      },
    },
    init = function()
      vim.opt.termguicolors = true
    end,
  },
}
