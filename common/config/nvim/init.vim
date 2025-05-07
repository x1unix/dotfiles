set nocompatible              " be iMproved, required
filetype off                  " required

" TODO: remove init.vim when migrated to other package manager.
if !has('nvim')
  error("this config file is only for neovim")
endif

" vim-plug autoinstall
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin(stdpath('data') . '/plugged')

" Plugins Start
Plug 'docker/docker'
Plug 'pangloss/vim-javascript'
Plug 'godlygeek/tabular'
Plug 'leafgarland/typescript-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jvirtanen/vim-hcl'
Plug 'charlespascoe/vim-go-syntax'
Plug 'sickill/vim-monokai'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'

" -- Neovim deps --
" Core deps
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'Shatur/neovim-session-manager'
Plug 'nvimdev/lspsaga.nvim'
Plug 'folke/which-key.nvim'

" Theming
Plug 'Mofiqul/vscode.nvim'
Plug 'f-person/auto-dark-mode.nvim'

" UI
Plug 'ThePrimeagen/harpoon'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'LukasPietzschmann/telescope-tabs'
Plug 'nvim-lualine/lualine.nvim'
Plug 'f-person/git-blame.nvim'
" Plug 'nvim-tree/nvim-web-devicons'

" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'

" Neotest - https://github.com/nvim-neotest/neotest
"Plug 'nvim-lua/plenary.nvim'
Plug 'antoinemadec/FixCursorHold.nvim'
"Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-neotest/neotest'

" Neotest - integration
Plug 'fredrikaverpil/neotest-golang'  " Go
Plug 'mrcjkb/rustaceanvim'            " Rust
Plug 'marilari88/neotest-vitest'      " vitest

" Coverage for neotest
Plug 'andythigpen/nvim-coverage'

" Git
Plug 'lewis6991/gitsigns.nvim', { 'tag': 'v0.9.0' } 

" Folding
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

" Neo Tree
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }

" LSP
Plug 'neovim/nvim-lspconfig', { 'tag': 'v1.0.0' }
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'pmizio/typescript-tools.nvim', { 'branch': 'master' }

" Go
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua'
Plug 'leoluz/nvim-dap-go'

" Gno
Plug 'x1unix/gno.nvim'

" JS/TS
Plug 'MunifTanjim/prettier.nvim'

" Misc
" TODO: migrate to lazy.nvim
Plug 'folke/lazydev.nvim'


" Plugins end
call plug#end()

" Lua bootstrap
lua require('.')

syntax enable
filetype plugin indent on    " required

