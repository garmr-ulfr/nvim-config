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

local colors = {
	rosewater = "#F5B8AB",
	flamingo = "#F29D9D",
	pink = palettes.pink[6],
	mauve = "#FF8F40",
	orange = "#db6d28",
	red = palettes.red[6],
	maroon = "#EB788B",
	peach = "#FAB770",
	yellow = "#FACA64",
	green = "#238636",
	teal = "#4CD4BD",
	sky = "#61BDFF",
	sapphire = "#4BA8FA",
	cyan = "#00BFFF",
	lavender = "#AD6FF7",
	magenta = "#FF61EF", -- #9d79d6
	comment = "#7D8296",
}

local syntax = {
	builtin_func = colors.mauve,
	builtin_type = colors.magenta, -- module, param, builtin type
	builtin_const = colors.lavender,
	type = colors.yellow,
	variable = "white.base",
	const = colors.flamingo,
	keyword = colors.magenta,
	func = colors.cyan,
	field = colors.sky,
	ident = colors.red,
	number = colors.maroon,
	string = palettes.green[6],
	comment = colors.comment,
	dep = palettes.red[5],
}

require("nightfox").setup({
	options = {
		transparent = true,
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = false, -- Non focused panes set to alternative background
		styles = {          -- Style to be applied to different syntax groups
			comments = "italic",
			keywords = "bold,italic",
			functions = "bold",
			types = "bold",
			conditionals = "NONE",
			constants = "italic",
			numbers = "NONE",
			operators = "NONE",
			strings = "NONE",
			variables = "NONE",
		},
		inverse = { -- Inverse highlight for different types
			match_paren = false,
			visual = false,
			search = false,
		},
		module_default = true,
		modules = { -- List of various plugins and additional options
			telescope = false,
		},
	},
	palettes = {},
	specs = {
		all = {
			syntax = {
				builtin0 = syntax.builtin_func,
				builtin1 = syntax.builtin_type,
				builtin2 = syntax.builtin_const,
				comment = syntax.comment,
				keyword = syntax.keyword,
				conditional = syntax.keyword,
				func = syntax.func,
				const = syntax.const,
				type = syntax.type,
				variable = syntax.variable,
				dep = syntax.dep,
				field = syntax.field,
				ident = syntax.ident,
				number = syntax.number,
				-- operator = palettes.purple[5],
				string = syntax.string,
			},
		}
	},
	groups = {
		all = {
			FloatTitle = { fg = colors.lavender },
			FloatBorder = { fg = colors.lavender },
			NormalFloat = { bg = "NONE" },
			MatchParen = { fg = colors.red, bg = palettes.gray[3], style = "bold" },
			['@module'] = { fg = syntax.type },
			['@variable.parameter'] = { fg = palettes.red[7] },
			['@constructor'] = { fg = syntax.func },
			['@boolean'] = { fg = syntax.builtin_const },
		},
	},
})

vim.cmd("ColorizerToggle")
