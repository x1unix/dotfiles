local highlight = {
  'IblIndent',
}

return {
  {
    -- Note: unfortunately plugin doesn't support current scope highlight.
    -- This feature is implemented using a different plugin - "mini.indentscope".
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    lazy = false,

    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = { highlight = highlight },
      whitespace = {
        highlight = highlight,
      },
    },
  },
}
