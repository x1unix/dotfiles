-- UFO for folding.
-- See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
--
-- See: https://github.com/kevinhwang91/nvim-ufo
return {
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        version = 'v1.5.0',
        config = function()
            require('ufo').setup({
                -- Use builtin treesitter for folding provider
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end
            })
        end
    },
}
