return {
	{
		'mason-org/mason-lspconfig.nvim',
		opts = {
			ensure_installed = {
				"lua_ls",
			},
			automatic_enable = {
				exclude = {
					"gopls",
				}
			},
		},
		dependencies = {
			{ 'mason-org/mason.nvim', opts = {} },
			'neovim/nvim-lspconfig',
			'saghen/blink.cmp',
		},
		config = function(_, opts)
			vim.keymap.del('n', 'grn')
			vim.keymap.del('n', 'gra')
			vim.keymap.del('n', 'grr')
			vim.keymap.del('n', 'gri')
			vim.keymap.del('n', 'grt')

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require('blink.cmp').get_lsp_capabilities({}, false)
			)

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

					if client:supports_method('textDocument/formatting') then
						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = args.buf,
							callback = function()
								if client.name == 'gopls' then
									require('go.format').goimports()
								else
									vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
								end
							end,
						})
					end
				end,
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local bufnr = event.buf
					local map = function(m, lhs, rhs, desc)
						local opts = { buffer = bufnr, desc = desc }
						vim.keymap.set(m, lhs, rhs, opts)
					end

					local buf_command = vim.api.nvim_buf_create_user_command

					buf_command(bufnr, 'LspFormat', function()
						vim.lsp.buf.format()
					end, { desc = 'Format buffer with language server' })

					-- LSP actions
					map('n', 'K', '<cmd>lua vim.lsp.buf.hover({ border = "rounded" })<cr>', "Hover")
					map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help({ border = "rounded" })<cr>', "Signature Help")

					local builtin = require('telescope.builtin')
					map('n', 'gr', function()
						builtin.lsp_references({ initial_mode = "normal" })
					end, "References")

					map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>zz', "Go to definition")
					map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>zz', "Go to declaration")
					map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>zz', "Go to implementation")
					map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>zz', "Go to type definition")

					map({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', "Format buffer")
					map('n', 'vca', '<cmd>lua vim.lsp.buf.code_action()<cr>', "Code action")
					map('n', 'vrn', '<cmd>lua vim.lsp.buf.rename()<cr>', "Rename symbol")
					map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', "Range code action")

					map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', "Show diagnostics")
				end
			})
			vim.lsp.config('*', {
				capabilities = capabilities,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = 'E',
						[vim.diagnostic.severity.WARN] = 'W',
						[vim.diagnostic.severity.INFO] = 'I',
						[vim.diagnostic.severity.HINT] = 'H',
					}
				}
			})

			require("mason-lspconfig").setup(opts)
		end
	},
}
