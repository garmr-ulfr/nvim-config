return {
	{
		'saghen/blink.cmp',
		version = '1.*',
		event = { 'InsertEnter', 'CmdlineEnter' },
		dependencies = {
			'L3MON4D3/LuaSnip',
			{
				'giuxtaposition/blink-cmp-copilot',
				dependencies = { 'zbirenbaum/copilot.lua' },
			},
		},
		opts = {
			keymap = {
				preset = 'none',
				['<C-n>'] = { 'select_next', 'fallback' },
				['<C-p>'] = { 'select_prev', 'fallback' },
				['<C-y>'] = { 'select_and_accept' },
				['<C-e>'] = { 'hide', 'fallback' },
				['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
			},
			snippets = { preset = 'luasnip' },
			sources = {
				default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
				providers = {
					copilot = {
						name = 'copilot',
						module = 'blink-cmp-copilot',
						score_offset = 100,
						async = true,
						transform_items = function(_, items)
							-- blink-cmp-copilot wraps the suggestion in a markdown code fence,
							-- and blink's doc renderer always highlights documentation as
							-- markdown, leaving concealed-but-occupied fence rows above and
							-- below. Move the code to `detail` so it's highlighted with the
							-- buffer's filetype directly, no fences, no empty rows.
							for _, item in ipairs(items) do
								if item.documentation and item.documentation.value then
									local code = item.documentation.value
										 :gsub('^```[^\n]*\n', '')
										 :gsub('\n```%s*$', '')
									item.detail = code
									item.documentation = nil
								end
							end
							return items
						end,
					},
				},
			},
			completion = {
				list = {
					selection = { preselect = false, auto_insert = false },
					max_items = 50,
				},
				menu = {
					border = 'rounded',
					max_height = 10,
					scrollbar = true,
					winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenuBorder,CursorLine:Visual,Search:None',
					draw = {
						columns = {
							{ 'label',    gap = 1 },
							{ 'kind' },
							{ 'kind_icon' },
						},
						components = {
							label = {
								width = { fill = true, max = 50 },
							},
							kind = {
								highlight = function(ctx)
									return 'CmpItemKind' .. ctx.kind
								end,
							},
							kind_icon = {
								text = function(ctx)
									return '[' .. (ctx.kind_icon or '') .. ']'
								end,
								highlight = function(ctx)
									return 'CmpItemKind' .. ctx.kind
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 150,
					window = {
						border = 'rounded',
						winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
					},
				},
				ghost_text = { enabled = true },
			},
			signature = {
				enabled = true,
				window = { border = 'rounded' },
			},
			appearance = {
				kind_icons = {
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
				},
			},
		},
	},
}
