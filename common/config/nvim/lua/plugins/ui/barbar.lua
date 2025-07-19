return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = false,
      auto_hide = true,
      sidebar_filetypes = {
        ['neo-tree'] = { event = 'BufWipeout' },
        ['dapui_watches'] = { event = 'BufWinLeave' },
        -- Possibly dapui_stacks, bapui_breakpoints, dapui_scopes, dapui_console, dap-repl
      },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
