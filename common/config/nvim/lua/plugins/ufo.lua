-- UFO for folding.
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- See: https://github.com/kevinhwang91/nvim-ufo
require('ufo').setup({
    -- Use builtin treesitter for folding provider
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

-- Hotkeys
require("which-key").add({
    { "z", group = "ufo: folds" },
    {
      "zR", function() require('ufo').openAllFolds() end,
      mode = "n", desc = "opem all folds",
    },
    {
      "zM", function() require('ufo').closeAllFolds() end,
      mode = "n", desc = "close all folds",
    },
})
