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

--- Restores ':LspInfo' and other goodies brutally removed in recent neovim versions.
---
--- P.S - I know that ':checkhealth vim.lsp' exists. I don't care.
M.register_goodies = function()
  local api = vim.api
  vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

  vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename()))
  end, {
    desc = 'Opens the Nvim LSP client log.',
  })

  local complete_client = function(arg)
    return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
  end

  local complete_config = function(arg)
    return vim
      .iter(vim.api.nvim_get_runtime_file(('lsp/%s*.lua'):format(arg), true))
      :map(function(path)
        local file_name = path:match('[^/]*.lua$')
        return file_name:sub(0, #file_name - 4)
      end)
      :totable()
  end

  api.nvim_create_user_command('LspStart', function(info)
    local servers = info.fargs

    -- Default to enabling all servers matching the filetype of the current buffer.
    -- This assumes that they've been explicitly configured through `vim.lsp.config`,
    -- otherwise they won't be present in the private `vim.lsp.config._configs` table.
    if #servers == 0 then
      local filetype = vim.bo.filetype
      for name, _ in pairs(vim.lsp.config._configs) do
        local filetypes = vim.lsp.config[name].filetypes
        if filetypes and vim.tbl_contains(filetypes, filetype) then
          table.insert(servers, name)
        end
      end
    end

    vim.lsp.enable(servers)
  end, {
    desc = 'Enable and launch a language server',
    nargs = '?',
    complete = complete_config,
  })

  api.nvim_create_user_command('LspRestart', function(info)
    local client_names = info.fargs

    -- Default to restarting all active servers
    if #client_names == 0 then
      client_names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for name in vim.iter(client_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for name in vim.iter(client_names) do
        vim.schedule_wrap(vim.lsp.enable)(name)
      end
      timer:close()
    end)
  end, {
    desc = 'Restart the given client',
    nargs = '?',
    bang = true,
    complete = complete_client,
  })

  api.nvim_create_user_command('LspStop', function(info)
    local client_names = info.fargs

    -- Default to disabling all servers on current buffer
    if #client_names == 0 then
      client_names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for name in vim.iter(client_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end
  end, {
    desc = 'Disable and stop the given client',
    nargs = '?',
    bang = true,
    complete = complete_client,
  })
end

return M
