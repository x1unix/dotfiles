local M = {}

-- Formatters by filetype configuration.
-- Passed to conform.nvim plugin.
--
-- list of available formatters: `:help conform-formatters`
-- see: https://github.com/stevearc/conform.nvim#formatters
M.formatters_by_ft = {
  sh = { 'shfmt' },
  bash = { 'shfmt' },
  lua = { 'stylua' },
  python = { 'isort', 'black' },
  proto = { 'buf' },
  go = { 'gofumpt', 'golangci-lint', 'goimports', stop_after_first = true },
  markdown = { 'prettier', stop_after_first = true },
  alloy = { 'alloy' },
}

M.format_on_save = {
  timeout_ms = 300,
  lsp_format = 'fallback',
}

M.formatters = {
  alloy = {
    command = 'alloy',
    args = {
      'fmt',
    },
  },
}

return M
