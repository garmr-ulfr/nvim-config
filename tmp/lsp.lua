local lsp = require('lsp-zero').preset('recommended')

lsp.ensure_installed({
	'gopls',
--	'lua-language-server',
})

-- lsp.nvim_workspace()

lsp.set_preferences({
    suggest_lsp_server = true,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
    }
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr, remap = false}

    require('lsp_signature').on_attach({
        bind = true,
        hint_enable = true,
        hint_prefix = '',
        floating_window = false,
        transparency = 100,
        doc_lines=0,
        always_trigger = true,
        fix_pos = false,
        extra_trigger_chars = {'(', ',', ')'}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        hi_parameter = "LspSignatureActiveParameter",
        handler_opts = {
            border = "none", -- double, single, shadow, none
        },
        floating_window_off_x = 2, -- adjust float windows x position.
        floating_window_off_y = 0, -- adjust float windows y position.
    }, bufnr)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
end)

lsp.setup()

require('go').setup({
	goimport = 'gopls',      -- goimport command, can be gopls[default] or goimport
	fillstruct = 'gopls',    -- can be nil (use fillstruct, slower) and gopls
	max_line_len = 128,      -- max line length in golines format, Target maximum line length for golines
	tag_transform = false,   -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
	tag_options = 'json=omitempty', -- sets options sent to gomodifytags, i.e., json=omitempty
	gotests_template = "",   -- sets gotests -template parameter (check gotests for details)
	gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
    comment_placeholder = '' ,
    verbose = false,         -- output loginf in messages
	lsp_cfg = false,          -- true: use non-default gopls setup specified in go/lsp.lua
	lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
	lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
	lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
	lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
	lsp_diag_hdlr = true, -- hook lsp diag handler
	lsp_diag_underline = true,
	-- virtual text setup
	lsp_diag_virtual_text = { space = 0, prefix = '■' },
	lsp_diag_signs = true,
	lsp_diag_update_in_insert = false,
	lsp_document_formatting = true,
	lsp_inlay_hints = {
		enable = true,
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
		parameter_hints_prefix = "\\(.*\\) ",
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
	gocoverage_sign = "█",
	sign_priority = 5, -- change to a higher number to override other signs
	dap_debug = true,  -- set to false to disable dap
	dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
	dap_debug_gui = {},                                     -- bool|table put your dap-ui setup here set to false to disable
	dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable

	dap_port = 38697,                                       -- can be set to a number, if set to -1 go.nvim will pickup a random port
	dap_timeout = 15,                                       --  see dap option initialize_timeout_sec = 15,
	dap_retries = 20,                                       -- see dap option max_retries
--	build_tags = "tag1,tag2",                               -- set default build tags
	textobjects = true,                                     -- enable default text jobects through treesittter-text-objects
	test_runner = 'go',                                     -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
	verbose_tests = true,                                   -- set to add verbose flag to tests deprecated, see '-v' option
	run_in_floaterm = true,                                -- set to true to run in float window. :GoTermClose closes the floatterm
	-- float term recommend if you use richgo/ginkgo with terminal color

	floaterm = {                                                          -- position
		posititon = 'right',                                           -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
		width = 0.45,                                                 -- width of float window if not auto
		height = 0.98,                                                -- height of float window if not auto
	},
	trouble = true,                                                       -- true: use trouble to open quickfix
	test_efm = true,                                                      -- errorfomat for quickfix, default mix mode, set to true will be efm only
	luasnip = true,                                                       -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
})

local cfg = require('go.lsp').config()
require('lspconfig').gopls.setup(cfg)

local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'copilot' },
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'path'},
        {name = 'nvim_lua'},
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
            ghost_text = true,
    }
})

--set max height of items
vim.cmd([[ set pumheight=6 ]])
