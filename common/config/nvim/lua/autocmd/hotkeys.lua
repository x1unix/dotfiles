-- Map return in normal node to add a new line and enter to Insert mode.
-- Register hook only for real text buffers to avoid conflict with QuickFix lists.
local bind_ignore_buftypes = {
  nofile = true,
  quickfix = true,
  help = true,
}

local filebuf_aug = vim.api.nvim_create_augroup('file_only_maps', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, {
  group = filebuf_aug,
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
