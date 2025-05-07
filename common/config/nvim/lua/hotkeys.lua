local wk = require("which-key")

-- See: https://github.com/folke/which-key.nvim
wk.setup({})

-- Note: some hotkeys are defined in plugins/*.lua

-- Leader
wk.add({
  { "<Leader>", group = "leader", },
  {
    "<Leader>\\", ":Neotree toggle<cr>",
    mode = "n", desc = "neotree",
  },
  -- Tabs --
  {
    "<Leader>j", ":tabp<cr>",
    mode = "n", desc = "tab: prev",
  },
  {
    "<Leader>k", ":tabn<cr>",
    mode = "n", desc = "tab: next",
  },
  -- Session manager --
  {
    "<Leader>M", "<cmd>SessionManager<cr>",
    mode = "n", desc = "session manager",
  },
  -- Telescope global shortcuts --
  {
    "<Leader>w", "<cmd>Telescope telescope-tabs list_tabs<cr>",
    mode = "n", desc = "list tabs",
  },
  {
    "<Leader>:", "<cmd>Telescope find_files<cr>",
    mode = "n", desc = "find files",
  },
  {
    "<Leader>g", "<cmd>Telescope live_grep<cr>",
    mode = "n", desc = "grep",
  },
  {
    "<Leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",
    mode = "n", desc = "find",
  },
  {
    "<Leader>b", "<cmd>Telescope buffers<cr>",
    mode = "n", desc = "buffers",
  },
  {
    "<Leader>fh", "<cmd>Telescope help_tags<cr>",
    mode = "n", desc = "tags",
  },
  {
    "<Leader>m", "<cmd>Telescope marks<cr>",
    mode = "n", desc = "marks",
  },
})

-- Telescope
wk.add({
  { "T", group = "telescope", },
  {
    "<Leader>T", "<cmd>Telescope<cr>",
    mode = "n", desc = "open telescope",
  },
  {
    "<Leader>Tr", "<cmd>Telescope lsp_references<cr>",
    mode = "n", desc = "lsp_references",
  },
  {
    "<Leader>Td", "<cmd>Telescope lsp_definitions<cr>",
    mode = "n", desc = "lsp_definitions",
  },
  {
    "<Leader>Ti", "<cmd>Telescope lsp_implementations<cr>",
    mode = "n", desc = "lsp_implementations",
  },
  {
    "<Leader>Ts", "<cmd>Telescope lsp_document_symbols<cr>",
    mode = "n", desc = "lsp_document_symbols",
  },
})

-- LSP hotkeys
wk.add({
  { "g", group = "goto" },
  {
    "gd", "<cmd>Telescope lsp_definitions<cr>",
    desc = "lsp: go to definitions",
  },
  {
    "gr", "<cmd>Telescope lsp_references<cr>",
    desc = "lsp: go to references",
  },
  {
    "gi", "<cmd>Telescope lsp_implementations<cr>",
    desc = "lsp: go to implementations",
  },
  {
    "gw", "<cmd>Telescope diagnostics<cr>",
    desc = "lsp: go to diagnostics",
  },
  -- LspSaga
  -- See: https://github.com/mistgc/config.nvim/blob/d1b52b86aba704f6eecb2e95cf3d663f736ebfa1/lua/utils.lua#L53
  {
    "ga", "<cmd>Lspsaga code_action<cr>",
    desc = "lsp: code actions",
  },
  {
    "gh", "<cmd>Lspsaga hover_doc<cr>",
    desc = "lsp: hover doc",
  },
  {
    "gs", "<cmd>Lspsaga signature_help<cr>",
    desc = "lsp: signature help",
  },
  {
    "g[", "<cmd>Lspsaga diagnostic_jump_prev<cr>",
    desc = "lsp: previous diagnostic",
  },
  {
    "g]", "<cmd>Lspsaga diagnostic_jump_next<cr>",
    desc = "lsp: next diagnostic",
  },
})

wk.add({
  { "<Leader>l", group = "lspsaga" },
  {
    "<Leader>lo", "<cmd>Lspsaga outline<cr>",
    desc = "lsp: outline",
  },
  {
    "<Leader>lr", "<cmd>Lspsaga rename<cr>",
    desc = "lsp: rename",
  },
  {
    "<Leader>ld", "<cmd>Lspsaga goto_definition<cr>",
    desc = "lsp: goto definition",
  },
  {
    "<Leader>lf", "<cmd>Lspsaga lsp_finder<cr>",
    desc = "lsp: finder",
  },
  {
    "<Leader>lp", "<cmd>Lspsaga preview_definition<cr>",
    desc = "lsp: preview_definition",
  },
  {
    "<Leader>ls", "<cmd>Lspsaga signature_help<cr>",
    desc = "lsp: signature_help",
  },
  {
    "<Leader>lw", "<cmd>Lspsaga show_line_diagnostics<cr>",
    desc = "lsp: show_line_diagnostics",
  },
  {
    "<Leader>lW", "<cmd>Lspsaga show_workspace_diagnostics<cr>",
    desc = "lsp: workspace_diagnostics",
  },
})
