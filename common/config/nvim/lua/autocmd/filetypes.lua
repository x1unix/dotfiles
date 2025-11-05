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
