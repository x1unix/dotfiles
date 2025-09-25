local config = require('config.ai')

return {
  -- It's impossible to imagine nowadays an editor w/o AI slop.
  -- Eventually this cancer reached NeoVim.
  --
  -- At least, this is somewhat useful to write unit tests.
  {
    'yetone/avante.nvim',
    version = false,
    event = 'VeryLazy',
    enabled = config.enabled,
    opts = config.opts,
    build = vim.fn.has('win32') ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
      or 'make BUILD_FROM_SOURCE=true',
    dependencies = {
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'Avante' },
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
      },
    },
  },
}
