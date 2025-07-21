-- Color table for highlights
-- stylua: ignore
local colors = {
	bg       = '#202328',
	fg       = '#bbc2cf',
	yellow   = '#ECBE7B',
	cyan     = '#008080',
	darkblue = '#081633',
	green    = '#98be65',
	orange   = '#FF8800',
	violet   = '#a9a1e1',
	magenta  = '#c678dd',
	blue     = '#51afef',
	red      = '#ec5f67',
}

local mode_color = {
	n = colors.red,
	i = colors.green,
	v = colors.blue,
	V = colors.blue,
	c = colors.magenta,
	no = colors.red,
	s = colors.orange,
	S = colors.orange,
	ic = colors.yellow,
	R = colors.violet,
	Rv = colors.violet,
	cv = colors.red,
	ce = colors.red,
	r = colors.cyan,
	rm = colors.cyan,
	['r?'] = colors.cyan,
	['!'] = colors.red,
	t = colors.red,
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 50
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local function get_lsp()
	local msg = 'No Active Lsp'
	local buf_ft = vim.bo[0].filetype
	local clients = vim.lsp.get_clients()
	if next(clients) == nil then
		return msg
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
end

local function spacer() return '%=' end

local url = vim.fn.system('git config --get remote.origin.url')
local repo = url:match("/(.*)%.git")

local function left_section(fg)
	return {
			 function() return '▊' end,
			 color = { fg = fg or colors.blue },
			 padding = { left = 0, right = 1 },
		 },
		 {
			 "mode",
			 icon = '',
			 color = function()
				 return { fg = fg or mode_color[vim.fn.mode()] }
			 end,
			 padding = { right = 1 },
		 },
		 {
			 'filename',
			 cond = conditions.buffer_not_empty,
			 path = 1,
			 color = { fg = fg or colors.magenta, gui = 'bold' },
			 file_status = true,
			 symbols = { modified = '*' },
		 },
		 {
			 'diagnostics',
			 sources = { 'nvim_diagnostic' },
			 symbols = { error = ' ', warn = ' ', info = ' ' },
			 diagnostics_color = {
				 error = { fg = fg or colors.red },
				 warn = { fg = fg or colors.yellow },
				 info = { fg = fg or colors.cyan },
			 },
		 }
end

local function middle_section(fg)
	-- Lsp server name .
	return spacer(),
		 {
			 get_lsp,
			 icon = ' LSP:',
			 color = { fg = fg or colors.cyan, gui = 'bold' },
			 cond = conditions.hide_in_width
		 },
		 {
			 function()
				 if get_lsp() == 'No Active Lsp' then
					 return ''
				 end
				 return ' '
			 end,
			 icon = "",
			 color = function()
				 if require("copilot.client").is_disabled() then
					 return { fg = fg or colors.red, gui = "bold" }
				 end
				 return { fg = fg or colors.green, gui = "bold" }
			 end,
		 },
		 spacer()
end

local function right_section(fg)
	return {
			 function()
				 return repo .. '[' .. vim.fn.FugitiveHead() .. ']'
			 end,
			 icon = '',
			 color = { fg = fg or colors.violet, gui = 'bold' },
		 },
		 {
			 'diff',
			 symbols = { added = ' ', modified = '󰈩 ', removed = ' ' },
			 diff_color = {
				 added = { fg = fg or colors.green },
				 modified = { fg = fg or colors.orange },
				 removed = { fg = fg or colors.red },
			 },
			 cond = conditions.hide_in_width,
		 },
		 {
			 function() return '▊' end,
			 color = { fg = fg or colors.blue },
			 padding = { left = 1, right = 0 },
		 }
end

-- Config
local config = {
	options = {
		always_divide_middle = false,
		component_separators = '',
		section_separators = '',
		theme = {
			normal = {
				a = { fg = colors.fg, bg = colors.bg },
				b = { fg = colors.fg, bg = colors.bg },
				c = { fg = colors.fg, bg = colors.bg },
			},
			inactive = {
				a = { fg = colors.fg, bg = colors.bg },
				b = { fg = colors.fg, bg = colors.bg },
				c = { fg = colors.fg, bg = colors.bg },
			},
		},
	},
	sections = {
		lualine_a = { left_section() },
		lualine_b = { middle_section() },
		lualine_c = { right_section() },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = { left_section('grey') },
		lualine_b = { middle_section('grey') },
		lualine_c = { right_section('grey') },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}

-- lualine.setup(config)
return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = config,
	},
}
