return {
	{
		'folke/which-key.nvim',
		opts = {
			spec = {
				{ "<leader>g", group = "git" },
			},
		},
	},
	{
		'tpope/vim-fugitive',
		keys = {
			{ "<leader>gs", vim.cmd.Git,         desc = "Git status" },
			{ "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{ "<leader>gS",  "<cmd>Gitsigns toggle_signs<CR>",              desc = "Toggle signs" },
			{ "<leader>gB",  "<cmd>Gitsigns blame<CR>",                     desc = "Full blame" },
			{ "<leader>gb",  "<cmd>Gitsigns blame_line<CR>",                desc = "Blame line" },
			{ "<leader>glb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle line blame" },
			{ "<leader>gw",  "<cmd>Gitsigns toggle_word_diff<CR>",          desc = "Toggle word diff" },
			{ "<leader>gd",  "<cmd>Gitsigns diffthis<CR>",                  desc = "Git diff" },
			{ "<leader>gh",  "<cmd>Gitsigns preview_hunk<CR>",              desc = "Preview hunk" },
		},
		opts = {
			signs                        = {
				add          = { text = '┃' },
				change       = { text = '┃' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			signs_staged                 = {
				add          = { text = '┃' },
				change       = { text = '┃' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			signs_staged_enable          = true,
			signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts      = {
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				delay = 300,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
			preview_config               = {
				-- Options passed to nvim_open_win
				style = 'minimal',
				relative = 'cursor',
				row = 0,
				col = 1
			},
		},
	},
}
