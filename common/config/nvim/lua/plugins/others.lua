-- See: https://github.com/f-person/git-blame.nvim
require('gitblame').setup {
  enabled = false,
}

-- See: https://github.com/Shatur/neovim-session-manager
local smconfig = require('session_manager.config')
require('session_manager').setup({
  autoload_mode = smconfig.AutoloadMode.Disabled,
  autosave_last_session = false,
})

-- See: https://github.com/hrsh7th/nvim-cmp#setup
local cmp = require('cmp')
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
}

-- Enable autosuggestions for commands
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})


-- See: https://github.com/nvim-treesitter/nvim-treesitter#modules
require('nvim-treesitter.configs').setup {
  ensure_installed = { "go", "gomod", "gosum" }
}

-- See: https://github.com/lewis6991/gitsigns.nvim#installation--usage
require('gitsigns').setup()

-- See: https://github.com/numToStr/Comment.nvim#configuration-optional
require('Comment').setup()

-- Prettier
-- See: https://github.com/MunifTanjim/prettier.nvim#setting-up-prettiernvim
require('prettier').setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

require('neo-tree').setup({
  close_if_last_window = true,
  filesystem = {
		follow_current_file = {
      enabled = true,
    },
		hijack_netrw_behavior = "open_default",
		filtered_items = {
			visible = true, -- when true, they will just be displayed differently than normal items
			hide_hidden = false
		}
	},
})
