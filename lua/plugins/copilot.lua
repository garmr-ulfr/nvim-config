return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "BufEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		opts = {},
	},
}
