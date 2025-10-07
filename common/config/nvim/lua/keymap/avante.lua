local config = require('config.ai')
if not config.enabled then
  return
end

local wk = require('which-key')
local icons = require('util.icons')

local function on_provider_select(provider)
  if not provider or provider == '' then
    return
  end

  local cfg = require('avante.config')
  if cfg.acp_providers[provider] then
    -- switch to ACP should be done manually
    cfg.override({
      provider = provider,
    })

    vim.notify('avante: switch to ACP provider: ' .. provider, vim.log.levels.INFO)
    return
  end

  local api = require('avante.api')
  api.switch_provider(provider)
end

wk.add({
  -- Avante adds hotkeys by default
  {
    '<Leader>a',
    group = 'avante',
    icon = icons.symbol_brain,
  },
  {
    '<Leader>ap',
    function()
      -- TODO
      vim.ui.select(config.enabled_providers, {
        prompt = 'Select Avante Provider',
      }, on_provider_select)
    end,
    mode = 'n',
    desc = 'avante: switch provider',
  },
})
