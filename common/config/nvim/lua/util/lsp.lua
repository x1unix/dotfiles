local M = {}

--- Creates and returns LSP capabilities with nvim-cmp completion support.
M.make_capabilities = function()
  return require('blink.cmp').get_lsp_capabilities({}, true)
end

M.lspconfig = function()
  if vim.lsp and vim.lsp.config then
    -- nvim 0.11+
    return vim.lsp.config
  end

  return require('lspconfig')
end

--- @param kv (string|table<string, vim.lsp.Config>)[] | table<string, vim.lsp.Config | function>
--- @param cb fun(name: string, cfg: vim.lsp.Config)
local function iter_lsp_configs(kv, cb)
  local caps = M.make_capabilities()
  for k, v in pairs(kv) do
    ---@type string
    local name
    ---@type vim.lsp.Config
    local cfg = {}
    if type(k) == 'number' and type(v) == 'string' then
      name = v
    end
    if type(k) == 'string' then
      name = k
    end

    -- Value can be a factory func.
    -- Factory also used to load servers on demand.
    if type(v) == 'function' then
      local ret_val = v()
      if not ret_val then
        goto continue
      end

      cfg = type(ret_val) == 'table' and ret_val or {}
    end

    if type(v) == 'table' then
      cfg = v
    end

    if not cfg.capabilities then
      cfg.capabilities = caps
    end

    cb(name, cfg)
    ::continue::
  end
end

--- @return fun(name: string, cfg: vim.lsp.Config)
local function get_lsp_setup()
  if vim.fn.has('nvim-0.11') == 1 then
    return function(name, cfg)
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end
  local lspconfig = require('lspconfig')
  return function(name, cfg)
    lspconfig[name].setup(cfg)
  end
end

--- Setups specified language servers.
---
--- Function is compatibility wrapper around vim.lsp.config introduced in v0.11+ and legacy 'lspconfig' module.
--- @param kv (string|table<string, vim.lsp.Config>)[] | table<string, vim.lsp.Config | function>
M.config = function(kv)
  --- @type fun(name: string, cfg: vim.lsp.Config)
  local cb = get_lsp_setup()
  iter_lsp_configs(kv, cb)
end

return M
