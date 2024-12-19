local utils = require("gno-nvim.utils")

local gs_gno = os.getenv("HOME") .. "/work/gs-gno"

require('gno-nvim').setup({
  gnoroot = function ()
    local cwd = vim.fn.expand("%:p:h")
    if cwd == "" then
      cwd = vim.fn.getcwd()
    end

    if utils.has_prefix(cwd, gs_gno) then
      return gs_gno
    end

    return nil
  end,
})
