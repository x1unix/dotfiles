-- Based on: https://github.com/pauchiner/ChinerNvim/blob/d2d46ad29376f96fb4c44eaf93a3eecafbbe5291/lua/plugins/lsp/none-ls.lua#L59
return {
    {
        "MunifTanjim/prettier.nvim",
        requirements = {
            "neovim/nvim-lspconfig",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            bin = "prettier",
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
        }
    }
}