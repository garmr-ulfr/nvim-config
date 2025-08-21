local symbols = {
	Text = "",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰇽",
	Variable = "󰂡",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "󰅲",
	Copilot = ""
}
-- local lspconfig = require('lspconfig')
-- lspconfig.util.on_setup = lspconfig.util.add_hook_after(
-- 	lspconfig.util.on_setup,
-- 	function(config, user_config)
-- 		config.capabilities = vim.tbl_deep_extend(
-- 			'force',
-- 			config.capabilities,
-- 			require('cmp_nvim_lsp').default_capabilities(),
-- 			vim.tbl_get(user_config, 'capabilities') or {}
-- 		)
-- 	end
-- )
--

-- local command = vim.api.nvim_create_user_command
--
-- command('LspWorkspaceAdd', function()
-- 	vim.lsp.buf.add_workspace_folder()
-- end, { desc = 'Add folder to workspace' })
--
-- command('LspWorkspaceList', function()
-- 	vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, { desc = 'List workspace folders' })
--
-- command('LspWorkspaceRemove', function()
-- 	vim.lsp.buf.remove_workspace_folder()
-- end, { desc = 'Remove folder from workspace' })

vim.lsp.set_log_level("error")

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
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/nvim-cmp',
			"L3MON4D3/LuaSnip",
		},
		config = function(_, opts)
			vim.keymap.del('n', 'grn')
			vim.keymap.del('n', 'gra')
			vim.keymap.del('n', 'grr')
			vim.keymap.del('n', 'gri')
			vim.keymap.del('n', 'grt')

			local cmp = require('cmp')
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
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

					-- Diagnostics
					map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', "Show diagnostics")
					map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', "Previous diagnostic")
					map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', "Next diagnostic")
				end
			})
			vim.lsp.config('*', {
				capabilities = capabilities,
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

			require("mason-lspconfig").setup(opts)

			local has_cmp_comparators, copilot_cmp = pcall(require, "copilot_cmp.comparators")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				completion = {
					completeopt = 'menu,menuone,noinsert,noselect',
				},
				window = {
					completion = {
						-- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						scrollbar = "║",
						winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:Visual,Search:None',
						autocomplete = {
							require("cmp.types").cmp.TriggerEvent.InsertEnter,
							require("cmp.types").cmp.TriggerEvent.TextChanged,
						},
					},
					documentation = {
						border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
						scrollbar = "║",
					},
				},
				mapping = {
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-e>'] = cmp.mapping.abort(),

					-- scroll up and down in the completion documentation
					['<C-u>'] = cmp.mapping.scroll_docs(-5),
					['<C-d>'] = cmp.mapping.scroll_docs(5),

				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				style = {
					winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
				},
				formatting = {
					fields = { 'abbr', 'menu', 'kind' },
					format = function(entry, item)
						-- local short_name = {
						-- 	nvim_lsp = 'LSP',
						-- 	nvim_lua = 'nvim'
						-- }
						--
						-- local menu_name = short_name[entry.source.name] or entry.source.name
						--
						-- item.menu = string.format('[%s]', menu_name)
						item.menu_hl_group = "CmpItemKind" .. item.kind
						item.menu = item.kind
						item.abbr = item.abbr:sub(1, 50)
						item.kind = '[' .. symbols[item.kind] .. ']'
						return item
					end,
				},
				experimental = {
					ghost_text = true,
				},
				sources = {
					{ name = 'copilot' },
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'nvim_lua' },
					{ name = 'luasnip' },
				},
				sorting = {
					priority_weight = 2,
					comparators = vim.tbl_filter(function(v) return v ~= nil end, {
						has_cmp_comparators and copilot_cmp.prioritize or nil,
						-- order matters here
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					}),
				},
				preselect = cmp.PreselectMode.None,
			})

			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			--set max height of items
			vim.cmd([[ set pumheight=6 ]])

			vim.lsp.enable('sourcekit')
		end
	},
}
