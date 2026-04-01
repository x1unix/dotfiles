return {
  {
    -- Markdown renderer. Required for LSP docs render.
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'Avante' },
    opts = {
      file_types = { 'markdown', 'Avante' },

      -- Fix double language icon in LSP hover.
      -- See: https://github.com/nvimdev/lspsaga.nvim/issues/1549
      code = {
        -- See: https://github.com/MeanderingProgrammer/render-markdown.nvim#code-blocks
        sign = false,
        language_icon = false,
        language_name = false,
      },

      heading = {
        -- Disable backgrounds for headings as it makes headings unreadable on light color scheme.
        backgrounds = {},
      },
    },
  },
}
