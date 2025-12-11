local wk = require('which-key')
local icons = require('util.icons')

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
    function()
      require('telescope.builtin').help_tags({
        layout_strategy = 'flex',
      })
    end,
    mode = 'n',
    desc = 'help',
  },
})
