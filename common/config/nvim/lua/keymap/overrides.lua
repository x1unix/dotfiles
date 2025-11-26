local wk = require('which-key')

wk.add({
  { 'n', 'nzzzv', mode = 'n', desc = 'next search result centered' },
  { 'N', 'Nzzzv', mode = 'n', desc = 'previous search result centered' },
  { 'g,', 'g,zvzz', mode = 'n', desc = 'next change centered' },
  { 'g;', 'g;zvzz', mode = 'n', desc = 'previous change centered' },
  { '<C-f>', '<C-f>zz', mode = 'n', desc = 'page half-down centered' },
  { '<C-b>', '<C-b>zz', mode = 'n', desc = 'page half-up centered' },
  { '<C-d>', '<C-d>zz', mode = 'n', desc = 'page down centered' },
  { '<C-u>', '<C-u>zz', mode = 'n', desc = 'page up centered' },
  { '<C-o>', '<C-o>zz', mode = 'n', desc = 'jump back centered' },
  { '<C-i>', '<C-i>zz', mode = 'n', desc = 'jump forwards centered' },
  { 'zt', 'zt5<C-y>', mode = 'n', desc = 'top this line' },
  { 'zb', 'zb5<C-e>', mode = 'n', desc = 'bottom this line' },
  { '>', '>gv', mode = 'v', desc = 'indent' },
  { '<', '<gv', mode = 'v', desc = 'dedent' },
  { 'k', 'gk', mode = 'n', desc = 'up' },
  { 'j', 'gj', mode = 'n', desc = 'down' },
  { 'p', 'P', mode = 'v', desc = 'paste' },

  -- Fancy cmdline using telescope
  { ';', ':', mode = 'n', desc = 'cmdline' },

  -- { '<leader>ttn', '<cmd> tabnew <CR>', mode = 'n', desc = 'create new tab' },
  -- { '<leader>ttq', '<cmd> tabclose <CR>', mode = 'n', desc = 'close tab' },
  -- { '<leader>ttk', '<cmd> tabNext <CR>', mode = 'n', desc = 'next tab' },
  -- { '<leader>ttj', '<cmd> tabprevious <CR>', mode = 'n', desc = 'previous tab' },
  -- { '<leader>sf', ":echo expand('%:p'},<CR>", mode = 'n', desc = 'display full path' },
})

local function expand_copy(expr)
  local p = vim.fn.expand(expr)
  if not p then
    return
  end

  vim.fn.setreg('+', p)
  vim.notify('Path copied to clipboard: "' .. p .. '"', vim.log.levels.INFO, {
    duration = 1000,
  })
end

wk.add({
  {
    'yp',
    function()
      expand_copy('%')
    end,
    mode = 'n',
    desc = 'Copy relative file path',
  },
  {
    'yP',
    function()
      expand_copy('%:p')
    end,
    mode = 'n',
    desc = 'Copy absolute file path',
  },
})
