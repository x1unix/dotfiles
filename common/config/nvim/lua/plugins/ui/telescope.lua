local os = require('util.os')

local function get_fzf_build_cmd()
  -- See: https://github.com/nvim-telescope/telescope-fzf-native.nvim/issues/120
  if os.is_win32() then
    return 'cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  end

  return 'make'
end

return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',

      -- Integrations
      'folke/trouble.nvim',
      'tiagovla/scope.nvim',

      -- Extensions
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'LukasPietzschmann/telescope-tabs',
      'ThePrimeagen/harpoon',
      'jonarrien/telescope-cmdline.nvim',

      -- Use fast native fzf finder. Requires CMake!
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = get_fzf_build_cmd(),
      },
    },
    config = function()
      local open_with_trouble = require('trouble.sources.telescope').open
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            '^.git/',
            '^.vscode/',
            '^.idea/',
            '^.DS_Store',
            'node_modules/',
          },

          -- Although trouble has autocmd to replace qfl, Telescope doesn't trigger it.
          -- As workaround: remap qfl hotkey.
          mappings = {
            i = { ['<C-q>'] = open_with_trouble },
            n = { ['<C-q>'] = open_with_trouble },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
          cmdline = {
            -- See: https://github.com/jonarrien/telescope-cmdline.nvim/tree/main#configuration
            picker = {
              layout_config = {
                width = 120,
                height = 25,
              },
            },
            mappings = {
              complete = '<Tab>',
              run_selection = '<C-CR>',
              run_input = '<CR>',
            },
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('harpoon')
      telescope.load_extension('ui-select')
      telescope.load_extension('telescope-tabs')
      telescope.load_extension('cmdline')
      require('telescope').load_extension('scope')
    end,
  },
}
