return {
    {
        'folke/lazydev.nvim',
        opts = {
            debug = nil,
            runtime = vim.env.VIMRUNTIME,
            library = { "nvim-dap-ui", "neotest" },
            integrations = {
                lspconfig = true,
                cmp = true,
            },
            enabled = function(root_dir)
                return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
            end,
        },
    }
}