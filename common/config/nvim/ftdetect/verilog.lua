-- Override extension as '.v' is detected as vlang.
vim.filetype.add({
  extension = {
    v = 'verilog',
  },
})
