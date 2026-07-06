-- Use tabs for different file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'alloy',
  callback = function()
    vim.bo.expandtab = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  callback = function()
    vim.bo.expandtab = false
  end,
})

-- Enable autoformat for verilog using LSP.
-- See: https://danielmangum.com/posts/setup-verible-verilog-neovim/
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'verilog', 'systemverilog' },
  callback = function(args)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})
