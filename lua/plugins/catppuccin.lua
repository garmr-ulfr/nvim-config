local palettes = {
	gray = {
		"#0d1117", "#161b22", "#21262d", "#30363d", "#484f58",
		"#6e7681", "#8b949e", "#b1bac4", "#c9d1d9", "#f0f6fc",
	},
	blue = {
		"#051d4d", "#0c2d6b", "#0d419d", "#1158c7", "#1f6feb",
		"#388bfd", "#58a6ff", "#79c0ff", "#a5d6ff", "#cae8ff",
	},
	green = {
		"#04260f", "#033a16", "#0f5323", "#196c2e", "#238636",
		"#2ea043", "#3fb950", "#56d364", "#7ee787", "#aff5b4",
	},
	yellow = {
		"#341a00", "#4b2900", "#693e00", "#845306", "#9e6a03",
		"#bb8009", "#d29922", "#e3b341", "#f2cc60", "#f8e3a1",
	},
	orange = {
		"#3d1300", "#5a1e02", "#762d0a", "#9b4215", "#bd561d",
		"#db6d28", "#f0883e", "#ffa657", "#ffc680", "#ffdfb6",
	},
	red = {
		"#490202", "#67060c", "#8e1519", "#b62324", "#da3633",
		"#f85149", "#ff7b72", "#ffa198", "#ffc1ba", "#ffdcd7",
	},
	purple = {
		"#271052", "#3c1e70", "#553098", "#6e40c9", "#8957e5",
		"#a371f7", "#bc8cff", "#d2a8ff", "#e2c5ff", "#eddeff",
	},
	pink = {
		"#42062a", "#5e103e", "#7d2457", "#9e3670", "#bf4b8a",
		"#db61a2", "#f778ba", "#ff9bce", "#ffbedd", "#ffdaec",
	}
}

return {
	'catppuccin/nvim',
	name = 'catppuccin',
	lazy = false,
	priority = 1000,
	enabled = false,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			background = {
				light = "latte",
				dark = "macchiato",
			},
			transparent_background = true, -- disables setting the background color.
			float = {
				transparent = true,
				solid = false,
			},
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = true,   -- sets terminal colors (e.g. `g:terminal_color_0`)
			no_italic = false,    -- Force no italic
			no_bold = false,      -- Force no bold
			no_underline = false, -- Force no underline
			styles = {
				comments = { "italic" }, -- Change the style of comments
				conditionals = {},
				loops = {},
				functions = { "bold" },
				keywords = { "bold", "italic" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = { "bold" },
				operators = {},
			},
			color_overrides = {
				macchiato = {
					rosewater = "#F5B8AB",
					flamingo = "#F29D9D",
					pink = palettes.pink[6],
					mauve = "#FF8F40",
					red = "#E66767",
					maroon = "#EB788B",
					peach = "#FAB770",
					yellow = "#FACA64",
					green = palettes.green[6],
					teal = "#4CD4BD",
					sky = "#61BDFF",
					sapphire = "#4BA8FA",
					blue = "#00BFFF",
					lavender = "#AD6FF7",
					text = "#C1C9E6",
					subtext1 = "#A3AAC2",
					subtext0 = "#8E94AB",
					overlay2 = "#7D8296",
					overlay1 = "#676B80",
					overlay0 = "#464957",
					surface2 = "#3A3D4A",
					surface1 = "#2F313D",
					surface0 = "#1D1E29",
					base = "#0b0b12",
					mantle = "#11111a",
					crust = "#191926",
				},
			},
			custom_highlights = function(colors)
				return {
					FloatTitle = { fg = colors.lavender },
					FloatBorder = { fg = colors.lavender },

					["@string"] = { fg = colors.green },
					keyword = { fg = colors.mauve, style = { "bold" } },
					["@keyword.function"] = { fg = colors.mauve, style = { "bold" } },
					["@keyword.conditional"] = { fg = colors.mauve, style = { "bold" } },
					["@keyword.repeat"] = { fg = colors.mauve, style = { "bold" } },
					["@keyword.return"] = { fg = colors.mauve, style = { "bold" } },
					["@function"] = { fg = colors.blue, style = { "bold" } },
					["@punctuation.bracket"] = { fg = colors.blue },
					comment = { fg = colors.overlay2, style = { "italic" } },
				}
			end,
			auto_integrations = true,
		})

		vim.cmd.colorscheme("catppuccin")
	end
}
