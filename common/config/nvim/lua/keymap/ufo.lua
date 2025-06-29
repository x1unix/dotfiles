-- Hotkeys
require("which-key").add({
    { "z", group = "ufo: folds" },
    {
      "zR", function() require('ufo').openAllFolds() end,
      mode = "n", desc = "open all folds",
    },
    {
      "zM", function() require('ufo').closeAllFolds() end,
      mode = "n", desc = "close all folds",
    },
})
