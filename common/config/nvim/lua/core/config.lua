-- Map leader key to SPACE --
vim.g.mapleader = " "

local opt = vim.opt  -- Shortcut for convenience

opt.backspace = { "start", "eol", "indent" }
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.cursorline = true
opt.smartcase = true
opt.title = true
opt.expandtab = true
opt.clipboard = "unnamedplus"
opt.backup = false
opt.writebackup = false
opt.showmatch = true
opt.ttyfast = true
opt.wildmode = { "longest", "list" }
opt.bomb = false

-- UFO folding config
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

