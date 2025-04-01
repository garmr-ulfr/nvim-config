require('mason').setup({})
require('mason-lspconfig').setup({})

local lspconfig = require('lspconfig')

lspconfig.util.on_setup = lspconfig.util.add_hook_after(
	lspconfig.util.on_setup,
	function(config, user_config)
		config.capabilities = vim.tbl_deep_extend(
			'force',
			config.capabilities,
			require('cmp_nvim_lsp').default_capabilities(),
			vim.tbl_get(user_config, 'capabilities') or {}
		)
	end
)

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local bufnr = event.buf
		local map = function(m, lhs, rhs)
			local opts = { buffer = bufnr }
			vim.keymap.set(m, lhs, rhs, opts)
		end

		local buf_command = vim.api.nvim_buf_create_user_command

		buf_command(bufnr, 'LspFormat', function()
			vim.lsp.buf.format()
		end, { desc = 'Format buffer with language server' })

		-- LSP actions
		map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
		map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
		map("n", "gr", "<cmd>Telescope lsp_references<cr>")

		map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>zz')
		map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>zz')
		map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>zz')
		map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>zz')

		map({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
		map('n', 'vca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
		map('n', 'vrn', '<cmd>lua vim.lsp.buf.rename()<cr>')
		map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

		-- Diagnostics
		map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
		map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
		map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	end
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = 'rounded' },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = 'E',
			[vim.diagnostic.severity.WARN] = 'W',
			[vim.diagnostic.severity.INFO] = 'I',
			[vim.diagnostic.severity.HINT] = 'H',
		}
	}
})

--  local sign = function(args)
--   vim.fn.sign_define(args.hl, {
--     texthl = args.hl,
--     text = opts[args.name],
--     numhl = ''
--   })
-- end
--
-- sign({ name = 'error', hl = 'DiagnosticSignError' })
-- sign({ name = 'warn', hl = 'DiagnosticSignWarn' })
-- sign({ name = 'hint', hl = 'DiagnosticSignHint' })
-- sign({ name = 'info', hl = 'DiagnosticSignInfo' })

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'rounded' }
)

local command = vim.api.nvim_create_user_command

command('LspWorkspaceAdd', function()
	vim.lsp.buf.add_workspace_folder()
end, { desc = 'Add folder to workspace' })

command('LspWorkspaceList', function()
	vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'List workspace folders' })

command('LspWorkspaceRemove', function()
	vim.lsp.buf.remove_workspace_folder()
end, { desc = 'Remove folder from workspace' })

-- local get_servers = require('mason-lspconfig').get_installed_servers
-- for _, server_name in ipairs(get_servers()) do
-- 	require('lspconfig')[server_name].setup({})
-- end

lspconfig.lua_ls.setup {}
lspconfig.jsonls.setup {}

require("garmr.configs.go")
