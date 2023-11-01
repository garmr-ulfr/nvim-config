local latte = require("catppuccin.palettes").get_palette "latte"
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = {
        comments = { "italic" }, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = function(colors)
		 return {
			FloatTitle = { fg = colors.lavender },
			FloatBorder = { fg = colors.lavender },

			["@string"] = {fg = colors.green},
		 }
	 end,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        harpoon = true,
        mason = true,
		  markdown = true,
		  lsp_trouble = true,
		  telescope = {
            enabled = true,
        }
    },
})

vim.cmd.colorscheme "catppuccin"
