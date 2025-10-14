local M = {}

--- @alias LspConfigFactory fun(): vim.lsp.Config|false|nil
--- @alias LspSetupCallback fun(name: string, cfg: vim.lsp.Config)

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

--- Iterates through LSP configurations and calls the callback for each valid configuration.
---
--- Supports three types of table entries:
--- 1. Array-style string values: `{"lua_ls", "gopls"}` - server names with default config
--- 2. Key-value with vim.lsp.Config: `{lua_ls = {settings = {...}}}` - server with custom config
--- 3. Key-value with factory function: `{lua_ls = function() return config_or_nil end}` - lazy-loaded config
---
--- Factory functions can return:
--- - `vim.lsp.Config` table to use the server with that configuration
--- - `false` or `nil` to skip the server (useful for conditional loading)
---
--- @param kv (string|table<string, vim.lsp.Config>)[] | table<string, vim.lsp.Config | LspConfigFactory>
--- @param cb LspSetupCallback
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

--- @return LspSetupCallback
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
---
--- Supports three types of table entries:
--- 1. Array-style string values: `{"lua_ls", "gopls"}` - server names with default config
--- 2. Key-value with vim.lsp.Config: `{lua_ls = {settings = {...}}}` - server with custom config
--- 3. Key-value with factory function: `{lua_ls = function() return config_or_nil end}` - lazy-loaded config
---
--- Factory functions can return:
--- - `vim.lsp.Config` table to use the server with that configuration
--- - `false` or `nil` to skip the server (useful for conditional loading)
---
--- @param kv (string|table<string, vim.lsp.Config>)[] | table<string, vim.lsp.Config | LspConfigFactory>
M.config = function(kv)
  --- @type LspSetupCallback
  local cb = get_lsp_setup()
  iter_lsp_configs(kv, cb)
end

return M
