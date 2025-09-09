-- local tempdir = vim.fn.finddir('gotests/templates', vim.fn.stdpath('config') .. "/**")
local get_current_gomod = function()
	local file = io.open('go.mod', 'r')
	if file == nil then
		return nil
	end

	local first_line = file:read()
	local mod_name = first_line:gsub('module ', '')
	file:close()
	return mod_name
end

local cfg = {
	capabilities = {
		textDocument = {
			completion = {
				completionItem = {
					commitCharactersSupport = true,
					deprecatedSupport = true,
					documentationFormat = { 'markdown', 'plaintext' },
					preselectSupport = true,
					insertReplaceSupport = true,
					labelDetailsSupport = true,
					snippetSupport = true,
					resolveSupport = {
						properties = {
							'edit',
							'documentation',
							'details',
							'additionalTextEdits',
						},
					},
				},
				completionList = {
					itemDefaults = {
						'editRange',
						'insertTextFormat',
						'insertTextMode',
						'data',
					},
				},
				contextSupport = true,
				dynamicRegistration = true,
			},
		},
	},
	filetypes = { 'go', 'gomod', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
	message_level = vim.lsp.protocol.MessageType.Error,
	cmd = { 'gopls' },
	flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
	settings = {
		gopls = {
			analyses = {
				atomicalign = false,
				unreachable = true,
				nilness = true,
				unusedvar = false,
				unusedparams = true,
				useany = true,
				unusedwrite = true,
				ST1003 = true,
				undeclaredname = true,
				fillreturns = true,
				nonewvars = false,
				fieldalignment = false,
				shadow = true,
			},
			codelenses = {
				generate = true,
				gc_details = true,
				test = true,
				tidy = true,
				vendor = true,
				regenerate_cgo = true,
				upgrade_dependency = true,
			},
			hints = {
				assignVariableTypes = false,
				compositeLiteralFields = false,
				compositeLiteralTypes = false,
				constantValues = false,
				functionTypeParameters = false,
				parameterNames = false,
				rangeVariableTypes = false,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			matcher = 'Fuzzy',
			diagnosticsDelay = '500ms',
			diagnosticsTrigger = 'Edit',
			symbolMatcher = 'FastFuzzy',
			semanticTokens = false, -- disable semantic tokens as treesitter is better
			vulncheck = 'Imports',
			['local'] = get_current_gomod(),
			gofumpt = false,
		},
	},
	handlers = {
		['textDocument/rangeFormatting'] = function(...)
			vim.lsp.handlers['textDocument/rangeFormatting'](...)
			if vim.fn.getbufinfo('%')[1].changed == 1 then
				vim.print('ran rangeFormatting')
			end
		end,
		['textDocument/formatting'] = function(...)
			vim.lsp.handlers['textDocument/formatting'](...)
			if vim.fn.getbufinfo('%')[1].changed == 1 then
				vim.print('ran formatting')
			end
		end,
	},
}

return {
	{
		'folke/which-key.nvim',
		opts = {
			spec = {
				{ "<leader>z", group = "go" },
			},
		},
	},
	{
		'ray-x/go.nvim',
		dependencies = {
			'ray-x/guihua.lua',
			'nvim-treesitter/nvim-treesitter',
			'neovim/nvim-lspconfig',
		},
		ft = { 'go', 'gomod', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
		opts = {
			go = 'go',
			goimports = 'gopls',
			gofmt = 'gopls',
			fillstruct = 'gopls',
			-- max_line_len = 0,
			tag_transform = false,
			tag_options = 'json=omitempty', -- sets options sent to gomodifytags, i.e., json=omitempty
			gotests_template = "testify",
			gotests_template_dir = "",
			comment_placeholder = '   ',
			verbose = false,
			lsp_cfg = cfg,
			lsp_gofumpt = false,
			lsp_on_attach = true,
			lsp_keymaps = function(bufnr)
				local map = function(mode, lhs, rhs, desc)
					local opts = { buffer = bufnr, remap = false, desc = desc }
					vim.keymap.set(mode, lhs, rhs, opts)
				end
				map("n", "<leader>zrt", "<cmd>GoTestFunc -n 1 -a -test.timeout=30s<CR>", "run test")
				map("n", "<leader>zrT", "<cmd>GoTestFile -n 1 -a -test.timeout=30s<CR>", "run file tests")
				map("n", "<leader>zRt", ":GoTestFunc -n 1 -a -test.timeout=30s -t ", "run test w/tags")
				map("n", "<leader>zRT", ":GoTestFile -n 1 -a -test.timeout=30s -t ", "run file tests w/tags")
				map("n", "<leader>zta", "<cmd>GoAddTest<CR>", "add test")
				map("n", "<leader>ztA", "<cmd>GoAddAllTest<CR>", "add all tests")
				map("n", "<leader>zfs", "<cmd>GoFillStruct<CR>", "fill struct")
				map("n", "<leader>zie", "<cmd>GoIfErr<CR>", "if err")
				map("n", "<leader>zgc", "gg<cmd>GoCodeLenAct<CR><C-o>", "GC analysis")
				map("n", "<leader>zcl", "<cmd>GoCodeLenAct<CR>", "code lens")
				map("n", "<leader>zct", "<cmd>GoTermClose<CR>", "close term")
				map("n", "<leader>zgd", ":GoDoc ", "go doc")
				map("n", "<leader>zgi", ":GoImpl ", "impl")
				map("n", "<leader>zmt", "<cmd>GoModTidy<CR>", "mod tidy")
				map("n", "<leader>ff", function() vim.lsp.buf.format() end, "format file")
			end,
			lsp_codelens = true,
			golangci_lint = {
				default = 'standard', -- set to one of { 'standard', 'fast', 'all', 'none' }
				-- disable = {'errcheck', 'staticcheck'}, -- linters to disable empty by default
				-- enable = {'govet', 'ineffassign','revive', 'gosimple'}, -- linters to enable; empty by default
				-- enable_only = {}, -- linters to enable only; empty by default, set to e.g. {'govet', 'ineffassign','revive', 'gosimple'}
				no_config = false,               -- true: golangci-lint --no-config
				severity = vim.diagnostic.severity.INFO, -- severity level of the diagnostics
			},
			diagnostics = {
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
			},
			lsp_document_formatting = true,
			lsp_inlay_hints = {
				enable = false,
			},
			lsp_semantic_highlights = false, -- use highlights from gopls, disable by default as gopls/nvim not compatible
			gopls_remote_auto = false, -- add -remote=auto to gopls
			gocoverage_sign = "λ",
			sign_priority = 5,
			textobjects = true, -- enable default text objects through treesittter-text-objects
			test_runner = 'go',
			verbose_tests = true,
			run_in_floaterm = true,
			floaterm = {
				posititon = 'right',
				width = 0.45,
				height = 0.98,
				title_colors = 'nord',
			},
			trouble = true,
			test_efm = false,
			luasnip = true
		},
		config = function(_, opts)
			require('go').setup(opts)
			-- local gopls_cfg = require('go.lsp').config()
			-- vim.lsp.config.gopls = gopls_cfg
			-- vim.lsp.enable('gopls')
		end,
	},
}
