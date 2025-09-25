local config = require('config.ai')
if not config.enabled then
  return
end

local wk = require('which-key')
local icons = require('util.icons')

wk.add({
  -- Avante adds hotkeys by default
  {
    '<Leader>a',
    group = 'avante',
    icon = icons.symbol_brain,
  },
})
