-- Neovide-specific keys
local function neovide_scaler(delta)
  return function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
  end
end

local function neovide_scale_reset()
  vim.g.neovide_scale_factor = 1
end

if vim.g.neovide then
  vim.keymap.set({ 'n', 'v' }, '<C-=>', neovide_scaler(0.1))
  vim.keymap.set({ 'n', 'v' }, '<C-->', neovide_scaler(-0.1))
  vim.keymap.set({ 'n', 'v' }, '<C-0>', neovide_scale_reset)

  vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelUp>', neovide_scaler(0.1))
  vim.keymap.set({ 'n', 'v' }, '<C-ScrollWheelDown>', neovide_scaler(-0.1))
end
