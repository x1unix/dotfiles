-- Session management
return {
    {
        "Shatur/neovim-session-manager",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local smconfig = require("session_manager.config")
            require("session_manager").setup({
                autoload_mode = smconfig.AutoloadMode.Disabled,
                autosave_last_session = false,
            })
        end
    }
}