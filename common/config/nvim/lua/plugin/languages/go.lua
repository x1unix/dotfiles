return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'saghen/blink.cmp',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local gopls_bin = os.getenv('GOPLS_BIN')
      if gopls_bin then
        vim.notify('Using custom gopls bin: ' .. gopls_bin, vim.log.levels.INFO)
      end

      require('go').setup({
        luasnip = true,
        lsp_keymaps = false,
        gopls_cmd = gopls_bin and { gopls_bin } or nil,
        lsp_cfg = {
          capabilities = require('util.lsp').make_capabilities(),

          -- Disable function arguments autofill as it works incorrectly.
          -- gopls returns a full function prototype as snippet and replacing prototype arguments with actual are PITA.
          settings = {
            gopls = {
              usePlaceholders = false,
            },
          },
        },
      })
      local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
