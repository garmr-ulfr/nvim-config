return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	enabled = true,
	dependencies = { 'norcalli/nvim-colorizer.lua' },
	config = function()
		require("config.colorscheme")
		vim.cmd.colorscheme("nightfox")
	end,
}
