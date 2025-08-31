local wk = require('which-key')
local icons = require('util.icons')

-- LSP hotkeys
wk.add({
  { 'g', group = 'goto' },
  {
    'gd',
    '<cmd>Telescope lsp_definitions<cr>',
    desc = 'lsp: go to definitions',
    icon = icons.symbol_class,
  },
  {
    'gr',
    '<cmd>Telescope lsp_references<cr>',
    desc = 'lsp: go to references',
    icon = icons.symbol_class,
  },
  {
    'gi',
    '<cmd>Telescope lsp_implementations<cr>',
    desc = 'lsp: go to implementations',
    icon = icons.symbol_class,
  },
  {
    'gw',
    '<cmd>Telescope diagnostics<cr>',
    desc = 'lsp: go to diagnostics',
  },
  -- LspSaga
  -- See: https://github.com/mistgc/config.nvim/blob/d1b52b86aba704f6eecb2e95cf3d663f736ebfa1/lua/utils.lua#L53
  {
    'ga',
    '<cmd>Lspsaga code_action<cr>',
    desc = 'lsp: code actions',
    icon = icons.bulb,
  },
  {
    'gh',
    '<cmd>Lspsaga hover_doc<cr>',
    desc = 'lsp: hover doc',
  },
  {
    'gs',
    '<cmd>Telescope lsp_document_symbols<cr>',
    desc = 'lsp: document symbols',
  },
  {
    'gS',
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = 'lsp: workspace symbols',
  },
  {
    'g[',
    '<cmd>Lspsaga diagnostic_jump_prev<cr>',
    desc = 'lsp: previous diagnostic',
  },
  {
    'g]',
    '<cmd>Lspsaga diagnostic_jump_next<cr>',
    desc = 'lsp: next diagnostic',
  },
})

wk.add({
  {
    '<Leader>l',
    group = 'lspsaga',
    icon = icons.symbol_event,
  },
  {
    '<Leader>lo',
    '<cmd>Lspsaga outline<cr>',
    desc = 'lsp: outline',
  },
  {
    '<Leader>lr',
    '<cmd>Lspsaga rename<cr>',
    desc = 'lsp: rename',
    icon = icons.action_rename,
  },
  {
    '<Leader>ld',
    '<cmd>Lspsaga goto_definition<cr>',
    desc = 'lsp: goto definition',
  },
  {
    '<Leader>lf',
    '<cmd>Lspsaga lsp_finder<cr>',
    desc = 'lsp: finder',
  },
  {
    '<Leader>lp',
    '<cmd>Lspsaga preview_definition<cr>',
    desc = 'lsp: preview_definition',
  },
  {
    '<Leader>ls',
    '<cmd>Lspsaga signature_help<cr>',
    desc = 'lsp: signature_help',
  },
  {
    '<Leader>lw',
    '<cmd>Lspsaga show_line_diagnostics<cr>',
    desc = 'lsp: show_line_diagnostics',
  },
  {
    '<Leader>lW',
    '<cmd>Lspsaga show_workspace_diagnostics<cr>',
    desc = 'lsp: workspace_diagnostics',
  },
})
