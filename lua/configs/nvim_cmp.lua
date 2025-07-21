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

local has_cmp_comparators, copilot_cmp = pcall(require, "copilot_cmp.comparators")

local cmp = require('cmp')
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
		--keep priority weight at 2 for much closer matches to appear above copilot
		--set to 1 to make copilot always appear on top
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

--set max height of items
vim.cmd([[ set pumheight=6 ]])
