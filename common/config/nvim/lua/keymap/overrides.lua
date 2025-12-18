local wk = require('which-key')

local function mini_anim_jump(motion)
  return "<cmd>lua vim.cmd('normal! " .. motion .. "'); MiniAnimate.execute_after('scroll', 'normal! zz')<cr>"
  -- local cmd = 'normal! ' .. motion
  -- return function()
  --   vim.cmd(cmd)
  --   MiniAnimate.execute_after('scroll', 'normal! zz')
  -- end
end

wk.add({
  { 'n', 'nzzzv', mode = 'n', desc = 'next search result centered' },
  { 'N', 'Nzzzv', mode = 'n', desc = 'previous search result centered' },
  { 'g,', 'g,zvzz', mode = 'n', desc = 'next change centered' },
  { 'g;', 'g;zvzz', mode = 'n', desc = 'previous change centered' },

  -- Mini animated jumps
  { '<C-f>', mini_anim_jump('<C-f>'), mode = 'n', desc = 'page half-down centered' },
  { '<C-b>', mini_anim_jump('<C-b>'), mode = 'n', desc = 'page half-up centered' },
  { '<C-d>', mini_anim_jump('<C-d>'), mode = 'n', desc = 'page down centered' },
  { '<C-u>', mini_anim_jump('<C-u>'), mode = 'n', desc = 'page up centered' },
  { '<C-o>', mini_anim_jump('<C-o>'), mode = 'n', desc = 'jump back centered' },
  { '<C-i>', mini_anim_jump('<C-i>'), mode = 'n', desc = 'jump forwards centered' },

  -- Other motions
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

local function expand_copy(expr, msg)
  local p = vim.fn.expand(expr)
  if not p then
    return
  end

  vim.fn.setreg('+', p)
  vim.notify(msg, vim.log.levels.INFO, {
    opts = {
      duration = 1000,
    },
  })
end

wk.add({
  {
    'yp',
    function()
      expand_copy('%:.', 'Relative path copied to clipboard')
    end,
    mode = 'n',
    desc = 'Copy relative file path',
  },
  {
    'yP',
    function()
      expand_copy('%:p', 'Path copied to clipboard')
    end,
    mode = 'n',
    desc = 'Copy absolute file path',
  },
})
