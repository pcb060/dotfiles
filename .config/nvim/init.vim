set showmatch               " show matching 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=2               " number of columns occupied by a tab 
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=120                  " set an 80 column border for good coding style
filetype plugin on          " used by nerdcommenter
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set ttyfast                 " Speed up scrolling in Vim

call plug#begin()

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }

  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-tree/nvim-tree.lua'

  Plug 'dense-analysis/ale'

  Plug 'phaazon/hop.nvim'
  
  Plug 'nvim-lua/plenary.nvim'
  Plug 'sindrets/diffview.nvim'

  Plug 'preservim/nerdcommenter'

  Plug 'nvim-lualine/lualine.nvim'

  Plug 'lukas-reineke/indent-blankline.nvim'

  Plug 'romgrk/barbar.nvim'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'm4xshen/autoclose.nvim'

call plug#end()
