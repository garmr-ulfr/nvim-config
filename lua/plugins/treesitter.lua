return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		-- branch = "main",
		opts = {
			auto_install = false,
			ensure_installed = {
				"bash",
				"dockerfile",
				"go",
				"json",
				"lua",
				"markdown",
				"vim",
			},
			highlight = {
				enable = true,
			},
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
}
