local wk = require('which-key')
local icons = require('util.icons')

-- Leader global hotkeys --
wk.add({
  {
    '<Leader>w',
    '<cmd>Telescope telescope-tabs list_tabs<cr>',
    mode = 'n',
    desc = 'list tabs',
  },
  {
    '<Leader>;',
    function()
      require('telescope.builtin').find_files({
        hidden = true,
      })
    end,
    mode = 'n',
    desc = 'find files',
  },
  {
    '<Leader>f',
    function()
      require('telescope.builtin').live_grep({
        hidden = true,
      })
    end,
    mode = 'n',
    desc = 'grep',
    icon = icons.action_search,
  },
  {
    '<Leader>/',
    function()
      require('telescope.builtin').current_buffer_fuzzy_find({
        hidden = true,
      })
    end,
    mode = 'n',
    desc = 'find in file',
    icon = icons.action_search,
  },
  {
    '<Leader>b',
    '<cmd>Telescope buffers<cr>',
    mode = 'n',
    desc = 'buffers',
  },
  {
    '<Leader>B',
    '<cmd>Telescope scope buffers<cr>',
    mode = 'n',
    desc = 'buffers: all',
  },
})

-- Telescope hotkey
wk.add({
  { 'T', group = 'telescope' },
  {
    '<Leader>T',
    '<cmd>Telescope<cr>',
    mode = 'n',
    desc = 'open telescope',
  },
  {
    '<Leader>Tr',
    '<cmd>Telescope lsp_references<cr>',
    mode = 'n',
    desc = 'lsp_references',
  },
  {
    '<Leader>Td',
    '<cmd>Telescope lsp_definitions<cr>',
    mode = 'n',
    desc = 'lsp_definitions',
  },
  {
    '<Leader>Ti',
    '<cmd>Telescope lsp_implementations<cr>',
    mode = 'n',
    desc = 'lsp_implementations',
  },
  {
    '<Leader>Ts',
    '<cmd>Telescope lsp_document_symbols<cr>',
    mode = 'n',
    desc = 'lsp_document_symbols',
  },
  {
    '<Leader>Tm',
    '<cmd>Telescope marks<cr>',
    mode = 'n',
    desc = 'marks',
  },
  {
    '<Leader>Th',
    '<cmd>Telescope help_tags<cr>',
    mode = 'n',
    desc = 'help',
  },
})
