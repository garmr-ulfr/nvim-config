-- local tempdir = vim.fn.finddir('gotests/templates', vim.fn.stdpath('config') .. "/**")
local util = require('garmr.util')

require('go').setup({
	goimports = 'gopls',          -- goimport command, can be gopls[default] or goimport
	gofmt = 'gopls',
	fillstruct = 'gopls',         -- can be nil (use fillstruct, slower) and gopls
	-- max_line_len = 128,			 -- max line length in golines format, Target maximum line length for golines
	tag_transform = false,        -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
	tag_options = 'json=omitempty', -- sets options sent to gomodifytags, i.e., json=omitempty
	gotests_template = "testify", -- sets gotests -template parameter (check gotests for details)
	gotests_template_dir = "",    -- sets gotests -template_dir parameter (check gotests for details)
	comment_placeholder = '',
	verbose = false,               -- output loginf in messages
	log_path = vim.fn.expand("$HOME") .. "/.local/state/nvim/gonvim.log",
	lsp_cfg = false,              -- true: use non-default gopls setup specified in go/lsp.lua
	lsp_gofumpt = false,          -- true: set default gofmt in gopls format to gofumpt
	lsp_fmt_async = false,        -- async lsp.buf.format
	lsp_on_attach = nil,          -- nil: use on_attach function defined in go/lsp.lua,
	lsp_keymaps = function(bufnr)
		local opts = { buffer = bufnr, remap = false }
		util.map("n", "<leader>rt", "<cmd>GoTestFunc -n 1 -a -test.timeout=30s<CR>", opts)
		util.map("n", "<leader>rat", "<cmd>GoTestFile -n 1 -a -test.timeout=30s<CR>", opts)
		util.map("n", "<leader>at", "<cmd>GoAddTest<CR>", opts)
		util.map("n", "<leader>aat", "<cmd>GoAddAllTest<CR>", opts)
		util.map("n", "<leader>fs", "<cmd>GoFillStruct<CR>", opts)
		util.map("n", "<leader>ie", "<cmd>GoIfErr<CR>", opts)
		util.map("n", "<leader>gc", "gg<cmd>GoCodeLenAct<CR><C-o>", opts)
		util.map("n", "<leader>cl", "<cmd>GoCodeLenAct<CR>", opts)
		util.map("n", "<leader>ct", "<cmd>GoTermClose<CR>", opts)
		util.map("n", "<leader>gd", ":GoDoc ", opts)
		util.map("n", "<leader>gi", ":GoImpl ", opts)
		util.map("n", "<leader>mt", "<cmd>GoModTidy<CR>", opts)
		util.map("n", "<leader>ff", function()
			require('go.format').goimports()
		end, opts)
	end,               -- set to false to disable gopls/lsp keymap
	lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
	diagnostics = false,
	lsp_document_formatting = true,
	lsp_inlay_hints = {
		enable = true,
		style = "eol",
		-- Only show inlay hints for the current line
		only_current_line = false,
		-- Event which triggers a refersh of the inlay hints.
		-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
		-- not that this may cause higher CPU usage.
		-- This option is only respected when only_current_line and
		-- autoSetHints both are true.
		only_current_line_autocmd = "CursorHold",
		-- whether to show variable name before type hints with the inlay hints or not
		-- default: false
		show_variable_name = true,
		-- prefix for parameter hints
		parameter_hints_prefix = "\\(.*\\) f",
		show_parameter_hints = true,
		-- prefix for all the other hints (type, chaining)
		other_hints_prefix = "=> ",
		-- whether to align to the lenght of the longest line in the file
		max_len_align = false,
		-- padding from the left if max_len_align is true
		max_len_align_padding = 1,
		-- whether to align to the extreme right or not
		right_align = false,
		-- padding from the right if right_align is true
		right_align_padding = 6,
		-- The color of the hints
		highlight = "Comment",
	},
	gocoverage_sign = "λ",
	sign_priority = 5,     -- change to a higher number to override other signs
	dap_debug = false,     -- set to false to disable dap
	dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
	dap_debug_gui = {},    -- bool|table put your dap-ui setup here set to false to disable
	dap_debug_vt = {
		enabled_commands = true,
		all_frames = true
	},                    -- bool|table put your dap-virtual-text setup here set to false to disable

	dap_port = 38697,     -- can be set to a number, if set to -1 go.nvim will pickup a random port
	dap_timeout = 15,     --	see dap option initialize_timeout_sec = 15,
	dap_retries = 20,     -- see dap option max_retries
	--	build_tags = "tag1,tag2",						-- set default build tags
	textobjects = true,   -- enable default text jobects through treesittter-text-objects
	test_runner = 'go',   -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
	verbose_tests = true, -- set to add verbose flag to tests deprecated, see '-v' option
	run_in_floaterm = true, -- set to true to run in float window. :GoTermClose closes the floatterm

	floaterm = {          -- position
		posititon = 'right', -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
		width = 0.45,      -- width of float window if not auto
		height = 0.98,     -- height of float window if not auto
	},
	trouble = true,       -- true: use trouble to open quickfix
	test_efm = true,     -- errorfomat for quickfix, default mix mode, set to true will be efm only
	luasnip = true,       -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
})

local cfg = require('go.lsp').config()
local gopls = cfg.settings.gopls
gopls.diagnosticsTrigger = "Edit"

gopls.analyses.atomicalign = false
gopls.analyses.fieldalignment = false

-- gopls.hints = {
-- 	compositeLiteralFields = true,
-- 	constantValues = true,
-- }

cfg.settings.gopls = gopls
require('lspconfig').gopls.setup(cfg)
