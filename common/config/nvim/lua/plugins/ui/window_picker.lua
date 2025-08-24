return {
  {
    -- Quick panel picker.
    -- Like leap.nvim, but for splits.
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts = {
      hint = 'floating-big-letter',
      selection_chars = 'FJDKSLACMRUEIWOQPHTGYVBNZX',
      filter_rules = {
        autoselect_one = false,
        bo = {
          filetype = { 'notify', 'incline' },
          buftype = { 'quickfix' },
        },
      },
      picker_config = {
        floating_big_letter = {
          font = 'ansi-shadow',
        },
      },
      show_prompt = false,
    },
    config = function(_, opts)
      require('window-picker').setup(opts)
    end,
  },
}
