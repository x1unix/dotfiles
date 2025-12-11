local wk = require('which-key')

wk.add({
  {
    '<leader>x',
    group = 'trouble',
    icon = {
      name = 'trouble',
      cat = 'filetype',
    },
  },
  {
    '<leader>xx',
    '<cmd>Trouble diagnostics toggle<cr>',
    desc = 'Diagnostics (Trouble)',
  },
  {
    '<leader>xX',
    '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
    desc = 'Buffer Diagnostics (Trouble)',
  },
  {
    '<leader>xf',
    '<cmd>Trouble lsp toggle focus=false<cr>',
    desc = 'LSP Definitions / references / ... (Trouble)',
  },
  {
    '<leader>xl',
    '<cmd>Trouble loclist toggle<cr>',
    desc = 'Location List (Trouble)',
  },
  {
    '<leader>xs',
    '<cmd>Trouble snacks toggle<cr>',
    desc = 'Snacks Results (Trouble)',
  },
  {
    '<leader>xq',
    '<cmd>Trouble qflist toggle<cr>',
    desc = 'Quickfix List (Trouble)',
  },
})
