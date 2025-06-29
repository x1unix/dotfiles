-- Fix filetypes for tsx & jsx
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.tsx',
  callback = function()
    vim.bo.filetype = 'typescriptreact'
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.jsx',
  callback = function()
    vim.bo.filetype = 'javascriptreact'
  end,
})

-- Call prettier
-- local function is_prettier_file(fname)
--   return fname:match('^.eslintrc')
-- end
--
-- vim.api.nvim_create_autocmd('BufWritePost', {
--   pattern = {
--     '*.jsx', '*.tsx', '*.js', '*.ts',
--   },
--   callback = function(args)
--     local bufnr = vim.api.nvim_get_current_buf()
--     local eslintrc = vim.fs.find(is_prettier_file, {
--       type = 'file',
--       limit = 32,
--       upward = true, -- Search upward through parent directories
--       path = vim.fn.expand("%:p:h"), -- Start from the current file's directory
--     })
--
--     if not eslintrc then
--       vim.schedule(function ()
--         vim.notify("ESLint config not found", vim.log.levels.WARN, { title = "ESLint" })
--       end)
--     end
--     print(vim.inspect(eslintrc))
--   end,
-- })
