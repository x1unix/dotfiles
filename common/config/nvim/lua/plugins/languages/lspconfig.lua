-- LSP Setup
--
-- Inspired by:
--   * https://github.com/radleylewis/nvim/blob/7e0001ae2c4c206f7b42da2866f8a6deaf0423c9/lua/plugins/nvim-lspconfig.lua#L64
--   * https://github.com/YasTheGoat/NeoConf/blob/de3cc569fef8e8854ba585b29a1f0ad58b9df1ad/lua/plugins/lsp-config.lua#L37
--
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('util.lsp').make_capabilities()

      -- Modify capabilities with folding range for nvim-ufo.
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true,
      -- }

      -- Enable LSP Diagnostic as virtual text below
      vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

      -- Managed by go.nvim
      -- lspconfig.gopls.setup({
      --   capabilities = capabilities,
      -- })

      lspconfig.terraformls.setup({
        capabilities = capabilities,
      })

      -- Fix filetypes for clangd. See: https://github.com/LazyVim/LazyVim/discussions/3997
      lspconfig.clangd.setup({
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'hpp' },
      })

      lspconfig.eslint.setup({
        on_attach = function(_client, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
          })
        end,
      })

      -- Sometimes Mason's buf_ls doesn't start
      lspconfig.buf_ls.setup({
        capabilities = capabilities,
      })

      -- Run ":checkhealth lsp" to see the status or to troubleshoot.
      -- Read ":help lspconfig" for details. Read ":help lspconfig-all" for the full list of server-specific details.
      --
      -- For servers not on your $PATH (e.g., jdtls, elixirls), you must manually set the cmd parameter when calling setup().
      -- For server-specific settings, see `:help lspconfig-setup`
      -- lspconfig.rust_analyzer.setup({
      --   capabilities = capabilities,
      --   settings = {
      --     ['rust-analyzer'] = {},
      --   },
      -- })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {},
        },
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                -- Depending on the usage, you might want to add additional paths here.
                vim.env.VIMRUNTIME,
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
            },
          })
        end,
      })
    end,
  },
}
