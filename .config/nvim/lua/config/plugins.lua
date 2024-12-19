local telescope = require("telescope")
telescope.setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
  }
}

telescope.load_extension('harpoon')
telescope.load_extension('ui-select')
telescope.load_extension('telescope-tabs')

local cmp = require('cmp')

-- See: https://github.com/Shatur/neovim-session-manager
local smconfig = require('session_manager.config')
require('session_manager').setup({
  autoload_mode = smconfig.AutoloadMode.Disabled,
  autosave_last_session = false,
})


-- See: https://github.com/hrsh7th/nvim-cmp#setup
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

-- See: https://github.com/nvim-treesitter/nvim-treesitter#modules
require('nvim-treesitter.configs').setup {
  ensure_installed = { "go", "gomod", "gosum" }
}

-- See: https://github.com/lewis6991/gitsigns.nvim#installation--usage
require('gitsigns').setup()

-- See: https://github.com/numToStr/Comment.nvim#configuration-optional
require('Comment').setup()

-- See: https://github.com/ray-x/go.nvim
require("go").setup()

-- UFO for folding.
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Use builtin treesitter for folding provider
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

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
