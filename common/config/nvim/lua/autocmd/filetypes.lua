-- Use tabs for Makefiles
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  callback = function()
    vim.bo.expandtab = false -- use real tabs
  end,
})
