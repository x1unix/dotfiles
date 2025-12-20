local os = require('util.os')

-- Autocompletion
return {
  {
    -- Modern autocompletion engine.
    -- Combines nvim-cmp and luasnip features.
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'Kaiser-Yang/blink-cmp-avante',
      'fang2hou/blink-copilot',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      signature = {
        -- Enable signature help.
        -- Use <C-d> and <C-u> for scroll.
        -- Use <C-k> to display signature.
        enabled = true,

        window = {
          border = 'single',
          show_documentation = true,
        },
      },
      sources = {
        default = {
          'avante',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'copilot',
        },
        providers = {
          -- See: https://github.com/Kaiser-Yang/blink-cmp-avante#installation
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {
              -- options for blink-cmp-avante
            },
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            async = true,
          },
        },
      },
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        preset = os.is_android() and 'super-tab' or 'default',

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = { documentation = { auto_show = true } },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
      },
    },
  },
}
