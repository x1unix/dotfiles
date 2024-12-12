-- LSP Setup
--
-- Inspired by:
--   * https://github.com/radleylewis/nvim/blob/7e0001ae2c4c206f7b42da2866f8a6deaf0423c9/lua/plugins/nvim-lspconfig.lua#L64
--   * https://github.com/YasTheGoat/NeoConf/blob/de3cc569fef8e8854ba585b29a1f0ad58b9df1ad/lua/plugins/lsp-config.lua#L37
--
local lspconfig = require('lspconfig')
local cmp = require('cmp')

cmp.setup {
  sources = {
    { name = 'nvim_lsp' }
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
-- Run ':checkhealth lsp' to see the status or to troubleshoot.
-- Read ':help lspconfig' for details. Read ':help lspconfig-all' for the full list of server-specific details.
--
-- For servers not on your $PATH (e.g., jdtls, elixirls), you must manually set the cmd parameter when calling setup().
lspconfig.rust_analyzer.setup{
  -- Server-specific settings. See `:help lspconfig-setup`
  capabilities = capabilities, 
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- ts_ls sucks and can't provide completion items.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
-- lspconfig.ts_ls.setup{}
lspconfig.ts_ls.setup{
  capabilities = capabilities, 
}

-- See: https://github.com/pmizio/typescript-tools.nvim#%EF%B8%8F-configuration
-- require('typescript-tools').setup{
--   settings = {
--     -- spawn additional tsserver instance to calculate diagnostics on it
--     separate_diagnostic_server = true,
--     -- "change"|"insert_leave" determine when the client asks the server about diagnostic
--     publish_diagnostic_on = "insert_leave",
--     -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
--     -- "remove_unused_imports"|"organize_imports") -- or string "all"
--     -- to include all supported code actions
--     -- specify commands exposed as code_actions
--     expose_as_code_action = {},
--     -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
--     -- not exists then standard path resolution strategy is applied
--     tsserver_path = nil,
--     -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
--     -- (see 💅 `styled-components` support section)
--     tsserver_plugins = {},
--     -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
--     -- memory limit in megabytes or "auto"(basically no limit)
--     tsserver_max_memory = "auto",
--     -- described below
--     tsserver_format_options = {},
--     tsserver_file_preferences = {},
--     -- locale of all tsserver messages, supported locales you can find here:
--     -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
--     tsserver_locale = "en",
--     -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
--     complete_function_calls = false,
--     include_completions_with_insert_text = true,
--     -- CodeLens
--     -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
--     -- possible values: ("off"|"all"|"implementations_only"|"references_only")
--     code_lens = "off",
--     -- by default code lenses are displayed on all referencable values and for some of you it can
--     -- be too much this option reduce count of them by removing member references from lenses
--     disable_member_code_lens = true,
--     -- JSXCloseTag
--     -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
--     -- that maybe have a conflict if enable this feature. )
--     jsx_close_tag = {
--         enable = false,
--         filetypes = { "javascriptreact", "typescriptreact" },
--     },
--   },
-- }
