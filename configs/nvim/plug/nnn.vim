nnoremap <C-f> :NnnPicker %:p:h<CR>
nnoremap <C-e> :NnnExplorer<CR>

lua << EOF
require'nnn'.setup {
	picker = {
		style = { border = 'rounded' } -- solid/rounded
	},
	replace_netrw = 'picker',
}
EOF
