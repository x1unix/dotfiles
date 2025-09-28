-- Map leader key to SPACE --
vim.g.mapleader = ' '

local opt = vim.opt -- Shortcut for convenience

opt.backspace = { 'start', 'eol', 'indent' }
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.cursorline = true
opt.smartcase = true
opt.title = true
opt.expandtab = true
opt.clipboard = 'unnamedplus'
opt.backup = false
opt.writebackup = false
opt.showmatch = true
opt.ttyfast = true
opt.wildmode = { 'longest', 'list' }
opt.bomb = false

-- configure default splits
vim.o.splitright = true
vim.o.splitbelow = true

-- highlight search
-- use ':noh' to clear.
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Rebalance splits on resize
vim.opt.equalalways = true -- re-balance on open/close window
vim.opt.eadirection = 'both' -- resize both directions
-- vim.opt.winminwidth = 5
-- vim.opt.winminheight = 3
