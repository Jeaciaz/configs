lua << EOF
require'nvim-tree'.setup {
	filters = {
		dotfiles = true
	}
}
EOF

nnoremap <C-f> :NvimTreeFindFile<CR>
nnoremap <C-t> :NvimTreeToggle<CR>
