return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"dockerfile",
				"go",
				"gomod",
				"gosum",
				"gotmpl",
				"json",
				"lua",
				"markdown",
				"vim",
			},
		},
		config = function(_, opts)
			require('nvim-treesitter').install(opts.ensure_installed)
			vim.api.nvim_create_autocmd('FileType', {
				callback = function()
					if pcall(vim.treesitter.start) then
						vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					end
				end,
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
}
