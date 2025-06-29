return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "go",
                "gomod",
                "gosum",
                "proto",
                "jsonc",
                "ini",
                "lua",
                "make",
                "nix",
                "php",
                "terraform",
                "typescript",
                "xml",
                "yaml",
            }
        }
    }
}