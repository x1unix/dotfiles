set nocompatible              " be iMproved, required
filetype off                  " required

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

if has('nvim')
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

else
  Plug 'preservim/nerdcommenter'
  Plug 'fatih/vim-go'
  Plug 'joshdick/onedark.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

" Plugins end

" Map the leader key to SPACE
let mapleader="\<SPACE>"

" Misc setup
set backspace=indent,eol,start
set number
set tabstop=2
set shiftwidth=2
set scrolloff=5
set sidescrolloff=5
set cursorline
set smartcase
set title
set expandtab
set clipboard=unnamedplus
set nobackup
set nowritebackup
set showmatch
set ttyfast " Fast scroll
set wildmode=longest,list " autocomplete command
set backspace=start,eol,indent " enable backspace at start
set nobomb " No BOM

" == ENVS ==
let $RC="$HOME/.vimrc"

call plug#end()

" Fix tsx&jsx filetypes
autocmd BufRead,BufNewFile *.tsx set filetype=typescriptreact
autocmd BufRead,BufNewFile *.jsx set filetype=javascriptreact

" Lua cfg
if has('nvim')
  " lua require('config')
  lua require('.')
  colorscheme vscode 
else
  " Vim Airline Setup
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#keymap#enabled = 0
  let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
  let g:Powerline_symbols='unicode'
  "let g:airline_theme='onedark'
  " End

  colorscheme codedark
endif

syntax enable
filetype plugin indent on    " required

