-- Map return in normal node to add a new line and enter to Insert mode.
-- Register hook only for real text buffers to avoid conflict with QuickFix lists.
local bind_ignore_buftypes = {
  nofile = true,
  quickfix = true,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    local bo = vim.bo[args.buf]
    if bind_ignore_buftypes[bo.buftype] or bo.readonly or not bo.modifiable then
      return
    end

    vim.keymap.set('n', '<CR>', 'a<CR><Esc>O', {
      buffer = args.buf,
      desc = 'Add new line in between',
    })
  end,
})
