return {
	{
		'folke/which-key.nvim',
		opts = {
			spec = {
				{ "<leader>np", group = "Go Playground" },
			},
		},
	},
	{
		'jeniasaigak/goplay.nvim',
		lazy = true,
		opts = {
			output_mode = 'formatted',
		},
		keys = {
			{
				'<leader>ngp',
				function()
					local gp = require('goplay')
					local bufExist = pcall(vim.api.nvim_buf_get_name, gp._activeBuf)
					if gp._activeBuf and bufExist then
						vim.cmd.bdelete { gp._activeBuf, bang = true }
						gp._activeBuf = nil
					else
						gp.goPlaygroundOpen()
					end
				end,
				desc = 'Open Go Playground'
			},
			{ '<leader>npe', ':GPExec<CR>',     desc = 'Execute Go Playground' },
			{ '<leader>npf', ':GPExecFile<CR>', desc = 'Execute Go Playground File' },
		},
	},
}
