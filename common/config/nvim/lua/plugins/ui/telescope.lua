return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",

      -- Extensions
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "LukasPietzschmann/telescope-tabs",
      "ThePrimeagen/harpoon",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            "^.git/",
            "^.vscode/",
            "^.idea/",
            "^.DS_Store",
            "node_modules/",
          },
        },
        -- pickers = {
        --   find_files = {
        --     hidden = false,
        --   },
        -- },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
          },
        }
      }

      telescope.load_extension("harpoon")
      telescope.load_extension("ui-select")
      telescope.load_extension("telescope-tabs")
    end
  }, 
}