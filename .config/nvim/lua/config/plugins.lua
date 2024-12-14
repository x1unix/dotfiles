require("telescope").load_extension('harpoon')

local cmp = require('cmp')

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

require('neo-tree').setup({
  close_if_last_window = true,
  filesystem = {
		follow_current_file = true,
		hijack_netrw_behavior = "open_default",
		filtered_items = {
			visible = true, -- when true, they will just be displayed differently than normal items
			hide_hidden = false
		}
	},
})
