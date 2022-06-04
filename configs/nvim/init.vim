:set number
:set relativenumber
:set autoindent
:set tabstop=2
:set shiftwidth=2
:set smarttab
:set softtabstop=2
set clipboard+=unnamedplus

call plug#begin()

Plug 'tpope/vim-surround' " Surrounding ysw)
Plug 'preservim/nerdtree' " NerdTree
Plug 'tpope/vim-commentary' " For Commenting gcc & gc
Plug 'vim-airline/vim-airline' " Status bar
Plug 'vim-airline/vim-airline-themes' " Status bar theme
Plug 'ryanoasis/vim-devicons' " Developer Icons
Plug 'tc50cal/vim-terminal' " Vim Terminal
Plug 'preservim/tagbar' " Tagbar for code navigation
Plug 'mg979/vim-visual-multi' " CTRL + N for multiple cursors
Plug 'nvim-lua/plenary.nvim' " Utils for null-ls
Plug 'neovim/nvim-lspconfig' " LSP Config for the lua script below
Plug 'jose-elias-alvarez/null-ls.nvim' " Diagnostic tools
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils' " Typescript utils for imports & such
Plug 'jiangmiao/auto-pairs' " Auto bracket opening/closing
Plug 'hrsh7th/nvim-cmp' " Autocompletion
Plug 'nvim-telescope/telescope.nvim' " Fuzzy navigation
Plug 'nvim-treesitter/nvim-treesitter' " Treesitter

" Utils for nvim-cmp
Plug 'hrsh7th/cmp-vsnip' 
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

set encoding=UTF-8
:set completeopt=menu,menuone,noselect

call plug#end()

lua require("lsp-config")

nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <Leader>b :ls<CR>:b<Space>

nmap <F8> :TagbarToggle<CR>

inoremap jk <Esc>
inoremap kj <Esc>

vnoremap <C-c> "+y

" NERDTree config
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:NERDTreeShowHidden=1

" airline config
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='sol'

" Telescope config
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>gf <cmd>Telescope current_buffer_fuzzy_find<cr>

lua << EOF
require('telescope').setup {
	defaults = {
		file_ignore_patterns = {"node_modules"}
	}
}
EOF
