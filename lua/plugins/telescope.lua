return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local telescope = require('telescope')
			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.git",
						"node_modules/.*",
						"dist/.*",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,       -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					}
				},
			})

			telescope.load_extension('fzf')

			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find Files' })
			vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Live Grep' })
			vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = 'Git Files' })
			vim.keymap.set('n', '<leader>bs', builtin.current_buffer_fuzzy_find, { desc = 'Buffer Search' })
			vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = 'Help Tags' })
		end
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}
