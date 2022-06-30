:set number
:set relativenumber
:set autoindent
:set tabstop=2
:set shiftwidth=2
:set smarttab
:set softtabstop=2
set termguicolors
set clipboard+=unnamedplus

lang ru_RU

call plug#begin()

Plug 'tpope/vim-surround' " Surrounding ysw)
Plug 'tpope/vim-commentary' " For Commenting gcc & gc
Plug 'JoosepAlviste/nvim-ts-context-commentstring' " Contextual comments
  Plug 'vim-airline/vim-airline' " Status bar
  Plug 'vim-airline/vim-airline-themes' " Status bar theme
Plug 'nvim-lua/plenary.nvim' " Utils for null-ls
Plug 'neovim/nvim-lspconfig' " LSP Config 
Plug 'jose-elias-alvarez/null-ls.nvim' " Diagnostic tools
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils' " Typescript utils for imports & such
Plug 'jiangmiao/auto-pairs' " Auto bracket opening/closing
Plug 'hrsh7th/nvim-cmp' " Autocompletion
Plug 'nvim-telescope/telescope.nvim' " Telescope
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Treesitter
Plug 'ellisonleao/gruvbox.nvim' " Gruvbox theme
Plug '~/arcadia/junk/moonw1nd/lua/telescope-arc.nvim' " Arc Telescope integration
Plug '~/arcadia/junk/kuzns/gitsigns.nvim_with_arc_support' " Arc gitsigns port
Plug 'editorconfig/editorconfig-vim' " Editorconfig
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
" Plug 'luukvbaal/nnn.nvim' " nnn integration
Plug 'kyazdani42/nvim-web-devicons' " icons for nvim-tree
Plug 'kyazdani42/nvim-tree.lua' " file explorer
Plug 'kevinhwang91/rnvimr' " file picker

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

" source $HOME/.config/nvim/plug/nnn.vim
source $HOME/.config/nvim/plug/nvim-tree.vim
source $HOME/.config/nvim/plug/rnvimr.vim

lua require("lsp-config")

set background=light
colorscheme gruvbox

" Keybindings
let mapleader = "§"

nnoremap <Leader>h :noh<CR>
noremap gG G
nnoremap <A-j> ddp
nnoremap <A-k> ddP

nmap <F8> :TagbarToggle<CR>

inoremap jk <Esc>
inoremap kj <Esc>
inoremap ∆ <Down>
inoremap ˚ <Up>
inoremap ˙ <Left>
inoremap ¬ <Right>

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

lua << EOF
require'telescope'.setup {
	defaults = {
		file_ignore_patterns = {"node_modules", "lock%.json"},
		initial_mode = "normal",
		scroll_strategy = "limit",
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
		}
	}
}

require'telescope'.load_extension'arc'
require'telescope'.load_extension'fzf'

vim.diagnostic.config {
	virtual_text = {
		source = true
	},
severity_sort = true
}

require'nvim-treesitter.configs'.setup {
	ensure_installed = { "typescript", "tsx" },
	context_commentstring = {
		enable = true
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

require'gitsigns'.setup {
	signs = {
    add          = {hl = 'GitSignsAdd'   , text = '◨', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = '#00f', text = '◨', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
}
EOF
