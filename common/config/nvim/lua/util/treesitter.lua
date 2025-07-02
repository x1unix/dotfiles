local function reload_highlights(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local has_ts_config, _ = pcall(require, 'nvim-treesitter.configs')
  if has_ts_config then
    vim.cmd('TSBufDisable highlight | TSBufEnable highlight')
    return
  end

  vim.treesitter.stop(bufnr)
  vim.treesitter.start(bufnr)
end

local M = {}

-- Installs autocmd hooks to reload TreeSitter queries to get custom highlight queries work.
M.install_reload_highlights_autocmd = function()
  --- Custom TS highlight queries are not applied on time
  --- due to loading order.
  --- Custom queries are applied after highlighting was done.
  --- This leads to missing highlights on custom queries.
  ---
  --- This issue can be solved only by restarting TS highlights.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function(args)
      local buf = args.buf
      vim.schedule(function()
        reload_highlights(buf)
      end)
    end,
  })
end

return M
