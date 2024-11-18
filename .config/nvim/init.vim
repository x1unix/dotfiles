set nocompatible              " be iMproved, required
filetype off                  " required

"call plug#begin('~/.vim/plugged')
call plug#begin(stdpath('data') . '/plugged')

" Plugins Start
Plug 'docker/docker'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
" Plug 'terryma/vim-multiple-cursors'
Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
Plug 'leafgarland/typescript-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'jvirtanen/vim-hcl'
Plug 'charlespascoe/vim-go-syntax'
Plug 'sickill/vim-monokai'
Plug 'tomasiser/vim-code-dark'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'

" Neo Tree
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v3.x' }

" Plugins end

"colorscheme codedark
"colorscheme pulumi
"colorscheme onedark 

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

" Open file menu
nnoremap <Leader>o :CtrlP<CR>
" Open buffer menu
nnoremap <Leader>b :CtrlPBuffer<CR>
" Open most recently used files
nnoremap <Leader>f :CtrlPMRUFiles<CR>
" Tabs
nnoremap <Leader>j :tabp<CR>
nnoremap <Leader>k :tabn<CR>

call plug#end()

" Gno
autocmd BufRead,BufNewFile *.gno set filetype=gno

" Lua cfg
if has('nvim')
  lua require('config')
endif

"colorscheme onedark 
colorscheme codedark 
syntax enable
filetype plugin indent on    " required

