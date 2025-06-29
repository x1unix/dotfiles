return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    cmd = { 'Neotree' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          hijack_netrw_behavior = 'open_default',
          -- filtered_items = {
          --   visible = true, -- when true, they will just be displayed differently than normal items
          --   hide_hidden = false,
          -- },
        },
      })

      -- Notify LSP server when file is renamed.
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require('neo-tree.events')
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
    end,
  },
}
