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
	-- root_dir = function(fname)
	-- 	local has_lsp, lspconfig = pcall(require, 'lspconfig')
	-- 	if has_lsp then
	-- 		local util = lspconfig.util
	-- 		return util.root_pattern('go.work', 'go.mod', '.git')(fname) or util.path.dirname(fname)
	-- 	end
	-- end,
	flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
	settings = {
		gopls = {
			-- more settings: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
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

local util = require('util')
local opts = {
	-- remap_commands = {}, -- Vim commands to remap or disable, e.g. `{ GoFmt = "GoFormat", GoDoc = false }`
	-- settings with {}; string will be set to ''. user need to setup ALL the settings
	-- It is import to set ALL values in your own config if set value to true otherwise the plugin may not work
	go = 'go',
	goimports = 'gopls',
	gofmt = 'gopls',
	fillstruct = 'gopls',
	-- max_line_len = 0,
	tag_transform = false,
	tag_options = 'json=omitempty', -- sets options sent to gomodifytags, i.e., json=omitempty
	gotests_template = "testify",
	gotests_template_dir = "",
	gotest_case_exact_match = true, -- true: run test with ^Testname$, false: run test with TestName
	comment_placeholder = '   ',
	-- icons = {breakpoint = '🧘', currentpos = '🏃'},  -- setup to `false` to disable icons setup
	verbose = false,
	lsp_semantic_highlights = false, -- use highlights from gopls, disable by default as gopls/nvim not compatible
	lsp_cfg = cfg,
	lsp_document_formatting = true,
	lsp_gofumpt = false,
	lsp_on_attach = true,
	lsp_keymaps = function(bufnr)
		local map = function(mode, lhs, rhs, desc)
			local opts = { buffer = bufnr, remap = false, desc = desc }
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		map("n", "<leader>zrt", "<cmd>GoTestFunc -n 1 -a -test.timeout=30s<CR>", "run test")
		map("n", "<leader>zrT", "<cmd>GoTestFile -n 1 -a -test.timeout=30s<CR>", "run file tests")
		map("n", "<leader>zta", "<cmd>GoAddTest<CR>", "add test")
		map("n", "<leader>ztA", "<cmd>GoAddAllTest<CR>", "add all tests")
		map("n", "<leader>zfs", "<cmd>GoFillStruct<CR>", "fill struct")
		map("n", "<leader>zie", "<cmd>GoIfErr<CR>", "if err")
		map("n", "<leader>zgc", "gg<cmd>GoCodeLenAct<CR><C-o>", "GC analysis")
		map("n", "<leader>zcl", "<cmd>GoCodeLenAct<CR>", "code lens")
		map("n", "<leader>zct", "<cmd>GoTermClose<CR>", "close term")
		map("n", "<leader>zgd", ":GoDoc ", "go doc")
		map("n", "<leader>zgi", ":GoImpl ", "impl")
		map("n", "<leader>xmt", "<cmd>GoModTidy<CR>", "mod tidy")
		map("n", "<leader>ff", function() vim.lsp.buf.format() end, "format file")
	end,
	lsp_codelens = true,
	golangci_lint = false,
	-- null_ls = false,
	diagnostics = false, -- set to false to disable vim.diagnostic.config setup,
	-- diagnostic = {  -- set diagnostic to false to disable vim.diagnostic.config setup,
	--   hdlr = false, -- hook lsp diag handler and send diag to quickfix
	--   underline = true,
	--   virtual_text = { spacing = 2, prefix = '' }, -- virtual text setup
	--   signs = {'', '', '', ''},  -- set to true to use default signs, an array of 4 to specify custom signs
	--   update_in_insert = false,
	-- },
	lsp_inlay_hints = {
		enable = true, -- this is the only field apply to neovim > 0.10
	},
	gopls_cmd = nil,         -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
	gopls_remote_auto = false, -- add -remote=auto to gopls
	gocoverage_sign = "λ",
	sign_priority = 5,       -- change to a higher number to override other signs
	-- dap_debug = true, -- set to false to disable dap
	-- dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
	--                          -- false: do not use keymap in go/dap.lua.  you must define your own.
	--                          -- Windows: Use Visual Studio keymap
	-- dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
	-- dap_debug_vt = { enabled = true, enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable
	--
	-- dap_port = 38697, -- can be set to a number, if set to -1 go.nvim will pick up a random port
	-- dap_timeout = 15, --  see dap option initialize_timeout_sec = 15,
	-- dap_retries = 20, -- see dap option max_retries
	-- dap_enrich_config = nil, -- see dap option enrich_config
	-- build_tags = "tag1,tag2", -- set default build tags
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
}

require('go').setup(opts)
