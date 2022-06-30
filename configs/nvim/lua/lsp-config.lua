local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local cmp = require("cmp")

local newbiz_path = "~/arcadia/taxi/frontend/services/newbiz-logistics-frontend"

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true })
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set select to false to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }
  }, {
    { name = buffer }
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }
  }, {
    { name = 'buffer' }
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

local cmp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local telescope_file_search = function ()
	require'telescope.builtin'.live_grep {
		search_dirs = {
			newbiz_path .. '/packages',
			newbiz_path .. '/services'
		}
	}
end

local telescope_arc_status = function ()
	require'telescope'.extensions.arc.status {
		preview_cmd = {
			staged = "arc diff --git --cached %s | delta --pager='less -SR'",
		  unstaged = "arc diff --git %s | delta --pager='less -SR'",
			untracked = "cat"
		}
	}
end

local telescope_arc_commits = function ()
	require'telescope'.extensions.arc.commits {
		preview_cmd = "arc show --git %s | delta --pager='less -SR'"
	}
end

local on_attach = function(client, bufnr)
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspFormattingSync lua vim.lsp.buf.formatting_sync(nil, 1000)")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

    buf_map(bufnr, "n", "K", ":LspHover<CR>")
    buf_map(bufnr, "n", "rn", ":LspRename<CR>")
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
    buf_map(bufnr, "n", "<F7>", ":LspFormatting<CR>")
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")

    buf_map(bufnr, "n", "gd", ":Telescope lsp_definitions<CR>")
    buf_map(bufnr, "n", "gy", ":Telescope lsp_type_definitions<CR>")
		buf_map(bufnr, "n", "gr", ":Telescope lsp_references<CR>")
		buf_map(bufnr, "n", "<Leader>ff", ":Telescope find_files<CR>")
		buf_map(bufnr, "n", "<Leader>fs", "", { callback = telescope_file_search })
		buf_map(bufnr, "n", "<Leader>b", ":Telescope buffers<CR>")
		buf_map(bufnr, "n", "<Leader>bg", ":Telescope current_buffer_fuzzy_find<CR>")
		buf_map(bufnr, "n", "<Leader>as", "", { callback = telescope_arc_status })
		buf_map(bufnr, "n", "<Leader>ac", "", { callback = telescope_arc_commits })

    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

lspconfig.tsserver.setup({
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.range_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)

    buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
    buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
    buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")

    on_attach(client, bufnr)
  end,
  flags = {
    update_in_insert = true,
  },
  capabilities = cmp_capabilities 
})

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.eslint_d,
  },
  on_attach = on_attach
})
