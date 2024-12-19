set nocompatible              " be iMproved, required
filetype off                  " required

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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'

if has('nvim')
  " Core deps
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'Shatur/neovim-session-manager'

  " Debugger
  Plug 'mfussenegger/nvim-dap'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'rcarriga/nvim-dap-ui'

  " UI
  Plug 'ThePrimeagen/harpoon'
  Plug 'numToStr/Comment.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
  Plug 'nvim-telescope/telescope-ui-select.nvim'

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

  " Gno
  " Plug 'x1unix/gno.nvim'
  Plug '~/prj/gno.nvim'

  " JS/TS
  Plug 'MunifTanjim/prettier.nvim'
else
  Plug 'preservim/nerdcommenter'
  Plug 'fatih/vim-go'
endif

" Plugins end

" Vim Airline Setup
"set guifont=Fura\ Code\ Light\ Nerd\ Font\ Complete:h16
let g:airline_powerline_fonts = 1
let g:airline#extensions#keymap#enabled = 0
let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
let g:Powerline_symbols='unicode'
"let g:airline_theme='onedark'
" End

" Map the leader key to SPACE
let mapleader="\<SPACE>"

" Misc setup
set backspace=indent,eol,start
set number
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard=unnamedplus
set nobackup
set nowritebackup
set showmatch
set backspace=start,eol,indent " enable backspace at start
set nobomb " No BOM

" == ENVS ==
let $RC="$HOME/.vimrc"

" == Hotkeys ==
" Open NerdTree
" nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>t :Neotree toggle<CR>

" Tabs
nnoremap <Leader>j :tabp<CR>
nnoremap <Leader>k :tabn<CR>

" Telescope
nnoremap <Leader>T <cmd>Telescope<cr>
nnoremap <Leader>: <cmd>Telescope find_files<cr>
nnoremap <Leader>/ <cmd>Telescope live_grep<cr>
nnoremap <Leader>b <cmd>Telescope buffers<cr>
nnoremap <Leader>fh <cmd>Telescope help_tags<cr>
nnoremap <Leader>m <cmd>Telescope marks<cr>
nnoremap <Leader>Tr <cmd>Telescope lsp_references<cr>
nnoremap <Leader>Td <cmd>Telescope lsp_definitions<cr>
nnoremap <Leader>Ti <cmd>Telescope lsp_implementations<cr>

" Session Manager
nnoremap <Leader>M <cmd>SessionManager<cr>

call plug#end()

" Gno
" autocmd BufRead,BufNewFile *.gno set filetype=gno

" Fix tsx&jsx filetypes
autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact

" Lua cfg
if has('nvim')
  lua require('config')
endif

"colorscheme onedark 
colorscheme codedark 
syntax enable
filetype plugin indent on    " required

