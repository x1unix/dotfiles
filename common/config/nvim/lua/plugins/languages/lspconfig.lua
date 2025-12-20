-- LSP Setup
--
-- Inspired by:
--   * https://github.com/radleylewis/nvim/blob/7e0001ae2c4c206f7b42da2866f8a6deaf0423c9/lua/plugins/nvim-lspconfig.lua#L64
--   * https://github.com/YasTheGoat/NeoConf/blob/de3cc569fef8e8854ba585b29a1f0ad58b9df1ad/lua/plugins/lsp-config.lua#L37
--
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local lsputil = require('util.lsp')
      local osutil = require('util.os')
      local capabilities = lsputil.make_capabilities()

      -- Enable LSP Diagnostic as virtual text below
      vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

      lsputil.config({
        'terraformls',
        'html',
        'emmet_language_server',
        'cssls',
        'tailwindcss',
        'yamlls',
        'jsonls',
        'bashls',
        buf_ls = {
          -- Sometimes Mason's buf_ls doesn't start
          capabilities = capabilities,
        },
        clangd = {
          -- Fix filetypes for clangd. See: https://github.com/LazyVim/LazyVim/discussions/3997
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'hpp' },
        },
        eslint = {
          on_attach = function(_client, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },
        lua_ls = {
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
        },
        perlpls = function()
          -- Check if perl is available and Perl::LanguageServer module is installed
          if vim.fn.executable('perl') == 0 then
            return false
          end

          -- Check if Perl::LanguageServer module is available
          local check_cmd = { 'perl', '-MPerl::LanguageServer', '-e', 'exit 0' }
          local _ = vim.fn.system(check_cmd)
          if vim.v.shell_error ~= 0 then
            return false
          end

          return {
            cmd = {
              'perl',
              '-MPerl::LanguageServer',
              '-e',
              'Perl::LanguageServer::run',
              '--',
              '--stdio',
            },
            capabilities = capabilities,
          }
        end,
      })
    end,
  },
}
