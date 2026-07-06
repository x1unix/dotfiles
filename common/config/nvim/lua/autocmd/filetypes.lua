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
local group = vim.api.nvim_create_augroup('lsp_format_on_save_verilog', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype

    if ft ~= 'verilog' and ft ~= 'systemverilog' then
      return
    end

    vim.api.nvim_clear_autocmds({
      group = group,
      buffer = bufnr,
      event = 'BufWritePre',
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          async = false,
        })
      end,
    })
  end,
})
