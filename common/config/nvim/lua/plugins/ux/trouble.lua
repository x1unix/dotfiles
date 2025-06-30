-- Trouble.nvim
-- A pretty list for showing diagnostics, references, telescope results,
-- quickfix and location lists to help you solve all the trouble your code is causing.
--
-- See: https://github.com/folke/trouble.nvim/blob/main/docs/examples.md

return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      modes = {
        test = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
        },
      },
    },
  },
}
