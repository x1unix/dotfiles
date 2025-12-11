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
      -- 'tiagovla/scope.nvim',

      -- Extensions
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'LukasPietzschmann/telescope-tabs',
      'ThePrimeagen/harpoon',

      -- Use fast native fzf finder. Requires CMake!
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = get_fzf_build_cmd(),
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      local custom_actions = require('util.telescope').actions
      telescope.setup({
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              width = 0.8,
              -- preview_height = 0.75,
            },
          },
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
            i = {
              ['<C-q>'] = custom_actions.qflist,
              ['<C-l>'] = custom_actions.loclist,
            },
            n = {
              ['<C-q>'] = custom_actions.qflist,
              ['<C-l>'] = custom_actions.loclist,
            },
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
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['dd'] = actions.delete_buffer,
                ['D'] = custom_actions.destroy_buffer,
              },
            },
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('harpoon')
      telescope.load_extension('ui-select')
      telescope.load_extension('telescope-tabs')
      require('telescope').load_extension('scope')
    end,
  },
}
