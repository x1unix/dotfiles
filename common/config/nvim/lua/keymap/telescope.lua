local wk = require('which-key')

-- Leader global hotkeys --
wk.add({
  {
    '<Leader>w',
    '<cmd>Telescope telescope-tabs list_tabs<cr>',
    mode = 'n',
    desc = 'list tabs',
  },
  {
    '<Leader>:',
    '<cmd>Telescope find_files<cr>',
    mode = 'n',
    desc = 'find files',
  },
  {
    '<Leader>f',
    '<cmd>Telescope live_grep<cr>',
    mode = 'n',
    desc = 'grep',
  },
  {
    '<Leader>/',
    '<cmd>Telescope current_buffer_fuzzy_find<cr>',
    mode = 'n',
    desc = 'find',
  },
  {
    '<Leader>b',
    '<cmd>Telescope buffers<cr>',
    mode = 'n',
    desc = 'buffers',
  },
  {
    '<Leader>h',
    '<cmd>Telescope help_tags<cr>',
    mode = 'n',
    desc = 'tags',
  },
  {
    '<Leader>m',
    '<cmd>Telescope marks<cr>',
    mode = 'n',
    desc = 'marks',
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
})
