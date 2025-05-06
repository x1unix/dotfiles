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
  pickers = {
    find_files = {
      hidden = false, -- Not needed anymore
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
  }
}

telescope.load_extension('harpoon')
telescope.load_extension('ui-select')
telescope.load_extension('telescope-tabs')

