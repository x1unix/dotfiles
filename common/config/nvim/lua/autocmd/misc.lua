-- Rebalance splits on window resize
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd('wincmd =') -- equalize all splits
  end,
})
