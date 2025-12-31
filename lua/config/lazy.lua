require("lazy").setup({
	checker = { enabled = true },
	spec = {
		-- theme
		-- {
		-- 	'catppuccin/nvim',
		-- 	name = 'catppuccin',
		-- 	priority = 1000,
		-- 	config = function()
		-- 		require('configs.catppuccin')
		-- 	end
		-- },
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ import = "plugins" },

		-- Util
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts_extend = { "spec" },
			opts = {
				preset = "helix",
				-- triggers = {},
				spec = {
					{ "<leader>f", group = "file" },
					{ "<leader>p", group = "project" },
				},
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			'mbbill/undotree',
			keys = {
				{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Undotree", mode = "n" }
			}
		},
		{ 'numToStr/Comment.nvim' },

		-- Visual
		{ 'nvim-tree/nvim-web-devicons', lazy = true },
		{
			'nvim-treesitter/playground',
			cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" }
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			optional = true,
			opts = {
				file_types = { "markdown", "copilot-chat" },
			},
			ft = { "markdown", "copilot-chat", "codecompanion" },
		},
		{ 'fei6409/log-highlight.nvim', ft = { "log" } },
	},
})
