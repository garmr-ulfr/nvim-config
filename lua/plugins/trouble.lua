return {
	{
		'folke/which-key.nvim',
		opts = {
			spec = {
				{ "<leader>t", group = "trouble" },
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			focus = true,
			keys = {
				["<cr>"] = "jump_close",
			},
		},
		keys = {
			{
				"<leader>tt",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer diagnostics",
			},
			{
				"<leader>tp",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Project diagnostics",
			},
		},
	},
}
